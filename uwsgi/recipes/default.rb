execute "apt-get update" do
  action :nothing
end

template "/etc/apt/sources.list.d/uwsgi.list" do
  owner "root"
  mode "0644"
  source "uwsgi.list.erb"
  notifies :run, resources("execute[apt-get update]"), :immediately
end

execute "Add uWSGI PPA key" do
  command "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B33D8107"
end

package "uwsgi-python"
package "uwsgi-extra"
