package "ufw" do
    :upgrade
end

service "ufw" do
  enabled true
  running true
  supports :status => true, :restart => true
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
