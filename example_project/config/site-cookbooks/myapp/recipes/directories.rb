DIRS = [
  "#{node[:apps][:example_project][:virtualenv]}/etc",
  "#{node[:apps][:example_project][:virtualenv]}/var",
  "#{node[:apps][:example_project][:virtualenv]}/src",
  "/var/www/#{node[:apps][:example_project][:domain]}",
  "/var/log/nginx/#{node[:apps][:example_project][:domain]}",
  "/var/log/apache2/#{node[:apps][:example_project][:domain]}"
]

DIRS.each do |dirname|
  directory dirname do
    owner "myuser"
    group "admin"
    mode 0755
    recursive true
  end
end
