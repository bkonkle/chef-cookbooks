define :rails_app, :action => :deploy, :user => "root", :mode => "0755" do
  case params[:action]
  when :deploy, :force_deploy, :rollback
    
    include_recipe "ruby"
    include_recipe "nginx::base"
  
    raise "Please provide the deploy details." unless params[:deploy_settings]
    raise "Please provide the config template to use." unless params[:template]

    grp = (params[:group] or params[:user])
    sites_dir = node[:sites][:dir]
    path = (params[:path] or "#{sites_dir}/#{params[:name]}")
  
    # Create necessary directories all at once
    %w{config log pids system backup}.each do |dir|
      directory "#{path}/shared/#{dir}" do
        owner params[:user]
        group grp
        mode params[:mode]
        recursive true
        action :create
      end
    end
  
    template "#{path}/shared/config/database.yml" do
      source "database.yml.erb"
      cookbook "rails"
      owner params[:user]
      group grp
      mode params[:mode]
      variables({
        :database => params[:database][:name],
        :username => params[:database][:username],
        :password => params[:database][:password],
        :host => params[:database][:host]
      })
    end

    deploy_revision path do
      user params[:user]
      group grp
      action params[:action]
      migration_command "rake db:migrate"
      environment "RAILS_ENV" => node[:rails][:environment]
      params[:deploy_settings].each_pair do |func_name, param_value|
        send(func_name, param_value)
      end
      notifies :run, "execute[installing required gems]"
      notifies :restart, resources(:service => "nginx")
    end
    
    execute "installing required gems" do
      command "sudo rake gems:install RAILS_ENV=#{node[:rails][:environment]}"
      cwd "#{path}/current"
      action :nothing
      ignore_failure true
    end
  
    template "/etc/nginx/sites-available/#{params[:name]}" do
      source params[:template]
      owner "root"
      group "root"
      mode "0644"
    end
  
    link "/etc/nginx/sites-enabled/#{params[:name]}" do
      to "/etc/nginx/sites-available/#{params[:name]}"
      notifies :restart, resources(:service => "nginx")
    end
  
  when :enable
    
    include_recipe "nginx::base"
    
    link "/etc/nginx/sites-enabled/#{params[:name]}" do
      to "/etc/nginx/sites-available/#{params[:name]}"
      notifies :restart, resources(:service => "nginx")
    end
    
  when :disable
    
    include_recipe "nginx::base"
    
    link "/etc/nginx/sites-enabled/#{params[:name]}" do
      action :delete
      only_if "test -f /etc/nginx/sites-enabled/#{params[:name]}"
      notifies :restart, resources(:service => "nginx")
    end
    
  end
end
