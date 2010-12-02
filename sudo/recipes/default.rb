include_recipe "users"

package "sudo" do
  action :upgrade
end

template "/etc/sudoers" do
  source "sudoers.erb"
  mode 0440
  owner "root"
  group "root"
  variables(
    :admin_group => node[:admin_group][:name],
    :sudoers_groups => node[:authorization][:sudo][:groups], 
    :sudoers_users => node[:authorization][:sudo][:users]
  )
end
