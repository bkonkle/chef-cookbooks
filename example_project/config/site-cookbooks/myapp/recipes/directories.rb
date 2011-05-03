DIRS = [
  "#{node[:application][:virtualenv]}/etc",
  "#{node[:application][:virtualenv]}/var",
  "#{node[:application][:virtualenv]}/src",
  "/var/www/#{node[:application][:domain]}",
  "/var/log/nginx/#{node[:application][:domain]}",
  "/var/log/apache2/#{node[:application][:domain]}"
]

DIRS.each do |dirname|
  directory dirname do
    owner "myuser"
    group "admin"
    mode 0755
    recursive true
  end
end
