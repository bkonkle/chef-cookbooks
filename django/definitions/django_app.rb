define :django_app, :action => :deploy, :user => "root", :mode => "0755",
       :packages => {} do
  include_recipe "python"
  
  raise "Please provide the deploy details." unless params[:deploy_settings]
  
  group = (params[:group] or user)
  sites_dir = node[:sites][:dir]
  path = (params[:path] or "#{sites_dir}/#{params[:name]}")
  venvs_dir = node[:django][:virtualenvs]
  venv = (params[:virtualenv] or "#{venvs_dir}/#{params[:name]}")
  server_type = node[:django][:app_server]
  requirements = (params[:requirements] or "#{path}/code/requirements.txt")

  directory path do
    owner params[:user]
    group group
    mode params[:mode]
    action :create
  end

  directory "#{path}/public" do
    owner params[:user]
    group group
    mode params[:mode]
    action :create
  end

  directory "#{path}/logs" do
    owner params[:user]
    group group
    mode params[:mode]
    action :create
  end

  directory "#{path}/backup" do
    owner params[:user]
    group group
    mode params[:mode]
    action :create
  end
  
  git "#{path}/code" do
    repository params[:deploy_settings][:repo]
    revision params[:deploy_settings][:revision]
    user params[:user]
    group group
    action :sync
  end
  
  # When passing params to another definition, things get crazy without this
  owner = params[:user]
  
  virtualenv params[:name] do
    path venv
    owner owner
    group group
    mode params[:mode]
    packages params[:packages]
    requirements requirements
  end
end
