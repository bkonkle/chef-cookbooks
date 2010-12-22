package "supervisor"

cookbook_file "/etc/supervisor/supervisord.conf" do
  source "supervisord.conf"
  owner "root"
  group "root"
  mode "0644"
end

service "supervisor" do
  supports :status => true, :restart => true, :reload => true
  reload_command "supervisorctl update"
  action [:enable, :start]
end
