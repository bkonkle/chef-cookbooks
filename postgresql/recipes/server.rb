include_recipe "postgresql::client"

if node[:postgresql][:version] == "9.0"
  # Add the needed PPA if PostgreSQL 9.0 is desired
  execute "add-apt-repository" do
    command "add-apt-repository ppa:pitti/postgresql && apt-get update"
    creates "/etc/apt/sources.list/d/pitti-postgresql-%s.list" % node[:lsb][:codename]
  end
end

%w{postgresql postgresql-server-dev-%s postgresql-contrib-%s}.each do |pkg|
  package pkg % node[:postgresql][:version] do
    action :upgrade
  end
end

if node[:platform] == "ubuntu" and node[:platform_version].to_f >= 10.10
  # The version number was removed in Maverick
  postgresql_service = "postgresql"
else
  postgresql_service = "postgresql-#{node[:postgresql][:version]}"
end
  

service "postgresql" do
  service_name postgresql_service
  supports :restart => true, :status => true, :reload => true
  action :nothing
end

template "#{node[:postgresql][:dir]}/pg_hba.conf" do
  source "pg_hba.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, resources(:service => "postgresql")
end

template "#{node[:postgresql][:dir]}/postgresql.conf" do
  source "postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode 0600
  notifies :restart, resources(:service => "postgresql")
end

unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

# Create users and grant privelages using the grants.sql template

grants_path = "/etc/postgresql/#{node[:postgresql][:version]}/main/grants.sql"

begin
  t = resources(:template => grants_path)
rescue
  Chef::Log.debug("Could not find previously defined grants.sql resource")
  t = template grants_path do
    path grants_path
    source "grants.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    action :create
  end
end

execute "postgresql-install-privileges" do
  command "cat #{grants_path} | sudo -u postgres psql"
  action :nothing
  subscribes :run, resources(:template => grants_path), :immediately
end
