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

if node[:django][:app_server] == "gunicorn"
  # Nginx can be used with Gunicorn without compiling a module
  include_recipe "nginx"
end
