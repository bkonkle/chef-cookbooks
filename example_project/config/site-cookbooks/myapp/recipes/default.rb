include_recipe "server"
include_recipe "postgresql::server"
include_recipe "nginx::latest"
include_recipe "memcached"
include_recipe "myapp::directories"

%w{landscape-common python-psycopg2 python-imaging}.each do |pkg|
  package pkg
end

virtualenv "example_project" do
  path node[:apps][:example_project][:virtualenv]
  owner "myuser"
  group "admin"
  mode "0755"
end

nginx_site "default" do
  template "nginx/default.conf.erb"
  action :enable
end

cookbook_file "#{node[:apps][:example_project][:virtualenv]}/etc/django.wsgi" do
  source "django.wsgi"
  owner "myuser"
  group "admin"
  mode "0644"
end

nginx_site "myapp" do
  template "nginx/myapp.conf.erb"
  action :enable
end

postgresql_database node[:apps][:example_project][:database][:name] do
  host "localhost"
  port 5432
  username "postgres"
  password node[:postgresql][:server_root_password]
  database node[:apps][:example_project][:database][:name]
  action :create_db
end

ufw_rule "ufw default deny" do
  action :deny
  default true
end

ufw_rule "allow SSH connections" do
  action :allow
  port 22
end

ufw_rule "allow HTTP traffic" do
  action :allow
  port 80
end
