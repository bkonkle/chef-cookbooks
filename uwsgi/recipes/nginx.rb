include_recipe "uwsgi"
package "build-essential"

# Recompiles Nginx to include the uWSGI module
unless File.directory?(node[:nginx][:source_path])
  begin
    log "Building nginx-uwsgi"
    
    directory node[:nginx][:source_path]
    
    configure_flags = node[:nginx][:configure_flags].join(" ")
    
    if configure_flags.include?('--with-http_ssl_module')
      package "libssl-dev"
    end
    
    bash "install_nginx-uwsgi" do
    user "root"
      cwd node[:nginx][:source_path]
      code <<-EOH
        apt-get -y build-dep nginx
        apt-get source nginx
      EOH
    end
    
    execute "Build Nginx" do
      command "cd #{node[:nginx][:source_path]}/nginx-* && dpkg-buildpackage"
      environment ({'CONFIGURE_OPTS' => "--add-module=/usr/share/doc/uwsgi-extra/nginx #{configure_flags}"})
    end
    
    dpkg_package "#{node[:nginx][:source_path]}/nginx_*.deb"
    
    execute 'echo "nginx hold" | dpkg --set-selections'
  rescue
    # Make sure that the directory goes away if there's an error, so that the
    # install will be attempted again on the next Chef run
    directory node[:nginx][:source_path] do
      action :delete
      recursive true
    end
  end
end

cookbook_file "/etc/nginx/uwsgi_params" do
  owner "root"
  source "uwsgi_params"
  mode "0644"
end

include_recipe "nginx::base"
