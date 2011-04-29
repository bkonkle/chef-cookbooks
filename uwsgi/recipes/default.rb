execute "apt-get update" do
  action :nothing
end

template "/etc/apt/sources.list.d/uwsgi.list" do
  owner "root"
  mode "0644"
  source "uwsgi.list.erb"
  notifies :run, resources("execute[apt-get update]"), :immediately
end

execute "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B33D8107" do
  not_if "apt-key export 'Launchpad PPA for uWSGI Maintainers'"
end

package "uwsgi"
