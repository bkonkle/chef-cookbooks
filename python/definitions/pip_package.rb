# Definition to install pip packages
#
# Params
# ------
#   :action - :install or :uninstall
#   :version - Either a version string, or nil for the latest version
#   :venv - A virtualenv to install to, or nil for system-wide packages
#   :user - The user for running the pip command
#   :group - The group used when running the pip command
#

define :pip_package, :action => :install, :version => nil, :venv => nil,
       :user => 'root', :group => 'root' do
  include_recipe "python"
  
  name = params[:name]
  version = params[:version]
  venv = params[:venv]
  
  case params[:action]
  when :install

    if version
      vstring = "==%s" % version
      installed = "[ `pip freeze | grep #{name}== | cut -d'=' -f3` = '#{version}' ]"
    else
      vstring = ""
      installed = "[ `pip freeze | grep #{name}== | cut -d'=' -f1` = '#{name}' ]"
    end
    
    if venv
      env = "-E #{venv} "
    else
      env = ""
    end
    
    execute "install-#{name}" do
      command "pip install #{env}#{name}#{vstring}"
      user params[:owner]
      group params[:group]
      not_if installed
    end  
    
  when :uninstall
    
    execute "uninstall-#{name}" do
      command "pip uninstall #{name}"
      only_if "[ `pip freeze | grep #{name}== | cut -d'=' -f1` = '#{name}' ]"
    end
  
  end
end