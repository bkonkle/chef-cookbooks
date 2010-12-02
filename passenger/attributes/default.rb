default.passenger[:version] = '3.0.0'
default.passenger[:root_path] = "#{node[:languages][:ruby][:gems_dir]}/gems/passenger-#{passenger[:version]}"
