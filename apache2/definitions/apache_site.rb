# Copyright 2008-2009, Opscode, Inc.

define :apache_site, :enable => true do
  include_recipe "apache2"
  
  if params[:enable]
    execute "a2ensite #{params[:name]}" do
      command "/usr/sbin/a2ensite #{params[:name]}"
      notifies :restart, resources(:service => "apache2")
      not_if do 
        ::File.symlink?("#{node[:apache][:dir]}/sites-enabled/#{params[:name]}") or
          ::File.symlink?("#{node[:apache][:dir]}/sites-enabled/000-#{params[:name]}")
      end
      only_if do ::File.exists?("#{node[:apache][:dir]}/sites-available/#{params[:name]}") end
    end
  else
    execute "a2dissite #{params[:name]}" do
      command "/usr/sbin/a2dissite #{params[:name]}"
      notifies :restart, resources(:service => "apache2")
      only_if do ::File.symlink?("#{node[:apache][:dir]}/sites-enabled/#{params[:name]}") end
    end
  end
end
