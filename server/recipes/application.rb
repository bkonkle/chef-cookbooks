include_recipe "server::default"
include_recipe "memcached"

# A recipe for a generic application server.  This should be included by a
# project-specific recipe

directory node[:sites][:dir] do
  owner node[:sites][:user]
  group node[:sites][:group]
  mode node[:sites][:mode]
end
