define :rails_app, :action => :deploy, :user => "root", :mode => "0755" do
  include_recipe "ruby"  
  
  raise "Please provide the deploy details." unless params[:deploy_settings]
  raise "Please provide the config template to use." unless params[:template]

  grp = (params[:group] or params[:user])
  sites_dir = node[:sites][:dir]
  path = (params[:path] or "#{sites_dir}/#{params[:name]}")
  
  # Create necessary directories all at once
  %w{config logs pids system}.each do |dir|
    directory "#{path}/shared/#{dir}" do
      owner params[:user]
      group grp
      mode params[:mode]
      recursive true
      action :create
    end
  
  template "#{path}/shared/config/database.yaml" do
    source "database.yml.erb"
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
  end
end
