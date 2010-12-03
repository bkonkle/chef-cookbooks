include_recipe "ruby"

define :rails_app, :action => :deploy, :user => "root", :mode => "0755" do
  raise "Please provide the deploy details." unless params[:deploy_settings]
  raise "Please provide the config template to use." unless params[:template]

  group = (params[:group] or user)
  sites_dir = node[:sites][:dir]
  path = (params[:path] or "#{sites_dir}/#{params[:name]}")

  directory path do
    owner params[:user]
    group group
    mode params[:mode]
    action :create
  end

  deploy_revision path do
    user params[:user]
    group group
    action params[:action]
    migration_command "rake db:migrate"
    environment node[:rails][:environment]
    params[:deploy_settings].each_pair do |func_name, param_value|
      send(func_name, param_value)
    end
  end
end
