package "libssl-dev"
package "rake"
package "libcurl4-openssl-dev"

gem_package "passenger" do
  version node[:passenger][:version]
end

nginx_path = "/usr/local/src/nginx-passenger"

unless File.directory?(nginx_path)
  begin
    
    log "Building nginx-passenger"
    
    directory nginx_path
    
    execute "install nginx build deps" do
      command "apt-get build-dep -y nginx"
      cwd nginx_path
    end
    
    execute "download nginx source package" do
      command "apt-get source nginx"
      cwd nginx_path
    end
    
    nginx_ver = `ls #{nginx_path} | grep nginx- | cut -d- -f2`
    nginx_src = "#{nginx_path}/nginx-#{nginx_ver}"
    passenger_root = `/var/lib/gems/1.8/bin/passenger-config --root`
    
    configure_opts = ["--with-http_ssl_module",
                       "--add-module=#{passenger_root}/ext/nginx"].join(" ")
    
    execute "compile nginx" do
      command "dpkg-buildpackage"
      cwd nginx_src
      environment "CONFIGURE_OPTS" => configure_opts
    end
    
    execute "install the custom packages" do
      command "dpkg -i nginx*.deb"
      cwd nginx_path
    end
    
    execute "hold the nginx package" do
      command 'echo "nginx hold" | sudo dpkg --set-selections'
    end
    
    execute "hold the nginx-dbg package" do
      command 'echo "nginx-dbg hold" | sudo dpkg --set-selections'
    end
    
  rescue
    
    # Make sure that the directory goes away if there's an error, so that the
    # install will be attempted again on the next Chef run
    directory nginx_path do
      action :delete
      recursive true
    end
    
  end
end

include_recipe "nginx::base"

template node[:nginx][:conf_dir] + "/passenger.conf" do
  source "passenger.conf.erb"
  owner "root"
  group "root"
  mode 0755
  notifies :restart, resources(:service => "nginx")
end
