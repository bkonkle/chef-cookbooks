define :django_app, :action => :deploy, :user => "root", :mode => "0755" do
  include_recipe "python"
  
  raise "Please provide the deploy details." unless params[:deploy_settings]
  
  user = (site[:user] or "root")
  group = (site[:group] or user)
  mode = (site[:mode] or "0775")
  sites_dir = node[:sites][:dir]
  venvs_dir = node[:django][:virtualenvs]
  path = (site[:path] or "#{sites_dir}/#{domain}")
  venv = (site[:venv] or "#{venvs_dir}/#{name}")
  server_type = node[:django][:app_server]
  packages = (site[:packages] or {})
  requirements = (site[:requirements] or "#{path}/code/requirements.txt")

  directory path do
    owner user
    group group
    mode mode
    action :create
  end

  directory "#{path}/public" do
    owner user
    group group
    mode mode
    action :create
  end

  directory "#{path}/logs" do
    owner user
    group group
    mode mode
    action :create
  end

  directory "#{path}/backup" do
    owner user
    group group
    mode mode
    action :create
  end
  
  git "#{path}/code" do
    repository site[:repo]
    revision site[:revision]
    user user
    group group
    action :sync
  end

  virtualenv name do
    path venv
    owner user
    group group
    mode mode
    packages packages
    requirements requirements
  end
end
