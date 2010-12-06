# The base Nginx configuration, to be included after installing Nginx with all
# desired compile options and modules.

service "nginx" do
  enabled true
  running true
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "nginx")
end

directory node[:sites][:dir] do
  owner node[:sites][:user]
  group node[:sites][:group]
  mode node[:sites][:mode]
end
