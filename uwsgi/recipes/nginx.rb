include_recipe "uwsgi"
include_recipe "nginx::base"
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
        apt-get build-dep nginx
        apt-get source nginx
        cd nginx-*
        CONFIGURE_OPTS="--add-module=/usr/share/doc/uwsgi-extra/nginx #{configure_flags}" dpkg-buildpackage
        cd ..
        dpkg -i nginx_*.deb
        echo "nginx hold" | dpkg --set-selections
      EOH
    end
  rescue
    # Make sure that the directory goes away if there's an error, so that the
    # install will be attempted again on the next Chef run
    directory node[:nginx][:source_path] do
      action :delete
      recursive true
    end
  end
end
