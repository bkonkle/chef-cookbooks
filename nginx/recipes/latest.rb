# Install the latest stable Nginx from the official PPA

execute "apt-get update" do
  action :nothing
end

template "/etc/apt/sources.list.d/nginx.list" do
  owner "root"
  mode "0644"
  source "nginx.list.erb"
end

execute "Add Nginx PPA key" do
  command "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C"
  notifies :run, resources("execute[apt-get update]"), :immediately
end

package "nginx-full"
