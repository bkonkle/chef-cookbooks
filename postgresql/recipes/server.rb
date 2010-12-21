include_recipe "postgresql::client"

POSTGRES_PACKAGES = ['postgresql', 'postgresql-server-dev-%s',
                     'postgresql-contrib-%s', 'libpq-dev']

if node[:postgresql][:version] == "9.0"
  # Add the needed PPA if PostgreSQL 9.0 is desired
  execute "add-apt-repository" do
    command "add-apt-repository ppa:pitti/postgresql && apt-get update"
    creates "/etc/apt/sources.list/d/pitti-postgresql-%s.list" % node[:lsb][:codename]
  end
end

POSTGRES_PACKAGES.each do |pkg|
  package pkg % node[:postgresql][:version] do
    action :upgrade
  end
end

service "postgresql" do
  service_name "postgresql-#{node[:postgresql][:version]}"
  supports :restart => true, :status => true, :reload => true
  action :nothing
end

template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :reload, resources(:service => "postgresql")
end

template "#{node[:postgresql][:dir]}/postgresql.conf" do
  source "postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, resources(:service => "postgresql")
end
