include_attribute "users"

default[:nginx][:conf_dir] = "/etc/nginx/conf.d"
default[:nginx][:worker_connections] = 1024

# The path to use when building Nginx from source
default[:nginx][:source_path] = "/usr/local/src/nginx"

default[:sites][:dir] = "/sites"
default[:sites][:user] = "root"
default[:sites][:group] = admin_group[:name]
default[:sites][:mode] = "0775"
