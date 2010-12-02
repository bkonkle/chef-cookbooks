default.passenger[:version] = '2.2.15'
default.passenger[:root_path] = "#{node[:languages][:ruby][:gems_dir]}/gems/passenger-#{passenger[:version]}"
