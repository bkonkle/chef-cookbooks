# Examples:
#
#   ufw_rule "Allow SSH connections" do
#     action :allow
#     port 22
#   end
#
#   ufw_rule "Allow Postgres connections from app server" do
#     action :allow
#     port 5432
#     protocol "tcp"
#     from "10.0.0.100"
#   end
#
#   ufw_rule "Set default firewall action" do
#     action :deny
#     default true
#   end

define :ufw_rule, :default => false, :delete => false do
  include_recipe "server::security"
  
  case params[:action]
  when :allow, :deny
  
    if params[:default]
      execute "ufw default #{params[:action]}" do
        user "root"
      end
    else

      # Build the command
      rule_cmd = "ufw "
      rule_cmd += "delete " if params[:delete]
      rule_cmd += "#{params[:action]} "
      if params[:from]
        rule_cmd += "from #{params[:from]} "
        rule_cmd += "to #{params[:to]} port " if params[:protocol]
      end
      rule_cmd += "#{params[:port]}" if params[:port]
      if params[:protocol] and not params[:from]
        rule_cmd += "/#{params[:protocol]}"
      end
      
      # Make sure ufw is enabled
      execute "yes | ufw enable" do
        user "root"
        only_if 'test "`ufw status`" = "Status: inactive"'
      end
      
      # Execute it
      execute rule_cmd  do
        user "root"
        notifies :reload, resources(:service => "ufw"), immediately
      end
    
    end
  
  when :disable
    
    execute "ufw disable" do
      user "root"
    end
  
  end
end
