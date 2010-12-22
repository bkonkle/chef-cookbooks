package "ufw" do
    :upgrade
end

service "ufw" do
  supports :status => true, :restart => true
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end
