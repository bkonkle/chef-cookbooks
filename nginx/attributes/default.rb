include_attribute "user"

default[:nginx][:version] = "0.7.67"
default[:nginx][:conf_dir] = "/etc/nginx/conf.d"

# The path to use when building Nginx from source
default[:nginx][:source_path] = "/usr/local/src/nginx"

default[:sites][:dir] = "/sites"
default[:sites][:user] = "root"
default[:sites][:group] = admin_group[:name]
default[:sites][:mode] = "0775"
