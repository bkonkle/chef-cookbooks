# Copyright 2008-2009, Opscode, Inc.

define :apache_conf do
  template "#{node[:apache][:dir]}/mods-available/#{params[:name]}.conf" do
    source "mods/#{params[:name]}.conf.erb"
    notifies :restart, resources(:service => "apache2")
    mode 0644
  end
end
