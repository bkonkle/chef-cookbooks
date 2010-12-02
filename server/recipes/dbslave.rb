include_recipe "server::default"

if node[:database][:type] == "postgresql"
  include_recipe "postgresql"
elsif node[:database][:type] == "mysql"
  include_recipe "mysql"
end
