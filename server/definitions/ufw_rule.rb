# Example:
#   ufw_rule "Allow Postgres connections from app server" do
#     action :allow
#     port 5432
#     protocol "tcp"
#     from "10.0.0.100"
#   end

define :ufw_rule, :default => false do
  include_recipe "server::security"
  
  if not [:allow, :deny].include?(params[:action])
    raise "Please provide a valid action for the rule, either allow or deny."
  end
  
  if params[:default]
    execute "ufw default #{params[:action]}" do
      user "root"
    end
  else

    # Build the command
    rule_cmd = "ufw #{params[:action]} "
    if params[:from]
      rule_cmd += "from #{params[:from]} "
      if params[:protocol]
        rule_cmd += "to #{params[:to]} port "
      end
    end
    if params[:port]
      rule_cmd += "#{params[:port]}"
    end
    if params[:protocol] and not params[:from]
      rule_cmd += "/#{params[:protocol]}"
    end
    
    # Execute it
    execute rule_cmd  do
      user "root"
    end
    
  end  
end
