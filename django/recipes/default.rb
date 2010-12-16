include_recipe "python"

directory node[:django][:virtualenvs] do
  owner node[:sites][:user]
  group node[:sites][:group]
  mode node[:sites][:mode]
end
