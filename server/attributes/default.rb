include_attribute "users"

default[:database][:type] = "postgresql"

default[:sites][:dir] = "/sites"
default[:sites][:user] = "root"
default[:sites][:group] = admin_group[:name]
default[:sites][:mode] = "0775"
