include_recipe "python"
include_recipe "server::application"

# Recipe to install individual Django sites
#
# Attributes
# ----------
#
#   :domain - [required] The domain name for the site
#   :server_type - Currently only supports "gunicorn"
#   :user - The user that will own the directories and virtualenv
#   :group - The group assigned to the directories and virtualenv
#   :mode - The mode used for directories and the virtualenv
#   :path - The path to use for the site
#   :venv - The virtualenv to install packages to
#   :packages - A hash of packages to install with pip
#   :requirements - The optional requirements file to install with pip
#

directory node[:django][:virtualenvs] do
  owner node[:sites][:user]
  group node[:sites][:group]
  mode node[:sites][:mode]
end

node[:django][:sites].each_pair do |name, site|
  # Required attributes
  raise "Please provide a repo location." unless node.has_key('repo')
  domain = (site[:domain] or raise 'Please provide a domain name.')
  
  
  user = (site[:user] or "root")
  group = (site[:group] or user)
  mode = (site[:mode] or "0775")
  sites_dir = node[:sites][:dir]
  venvs_dir = node[:django][:virtualenvs]
  path = (site[:path] or "#{sites_dir}/#{domain}")
  venv = (site[:venv] or "#{venvs_dir}/#{name}")
  server_type = (site[:server_type] or "gunicorn")
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
