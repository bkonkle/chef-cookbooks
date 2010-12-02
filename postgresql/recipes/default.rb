# A basic Postgres recipe

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
