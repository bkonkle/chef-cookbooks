include_recipe "python"

directory node[:sites][:dir] do
  owner node[:sites][:user]
  group node[:sites][:group]
  mode node[:sites][:mode]
end

directory node[:django][:virtualenvs] do
  owner node[:sites][:user]
  group node[:sites][:group]
  mode node[:sites][:mode]
end
