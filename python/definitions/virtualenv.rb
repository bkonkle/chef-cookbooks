# Definition to create virtualenvs
#
# Params
# ------
#   :action - :create or :delete
#   :path - The location of the virtualenv - defaults to the name
#   :owner - The owner used to create the dir and run the 'virtualenv' command
#   :group - The group used when creating the dir and virtualenv
#   :mode - The mode for the parent directory of the virtualenv
#   :packages - A hash of packages to install with pip
#   :requirements - The path to a requirements file to install with pip
# 

define :virtualenv, :action => :create, :owner => "root", :mode => 0755,
       :packages => {} do
  include_recipe "python"
  
  name = params[:name]
  path = params[:path] or name
  group = params[:group] or params[:owner]
  
  requirements = params[:requirements]
  
  case params[:action]
  when :create
  
    # Manage the directory.
    directory path do
      owner params[:owner]
      group group
      mode params[:mode]
    end
    
    execute "create-virtualenv-#{name}" do
      user params[:owner]
      group group
      command "virtualenv #{path}"
      not_if "test -f #{path}/bin/python"
    end
    
    params[:packages].each_pair do |pkg, ver|
      pip_package pkg do
        action :install
        version ver
        virtualenv path
        user params[:owner]
        group group
      end
    end
    
    if requirements
      log "Installing pip requirements"
      
      execute "install-pip-requirements" do
        user params[:owner]
        group group
        command "pip install -E #{path} -r #{requirements}"
        only_if "test -f #{requirements}"
        ignore_failure true
      end
    end
  
  when :delete
    
    directory path do
      action :delete
      recursive true
    end
  
  end
end
