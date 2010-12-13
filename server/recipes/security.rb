package "ufw" do
    :upgrade

service "ufw" do
  enabled true
  running true
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
