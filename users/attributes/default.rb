default[:users] = {}
default[:groups] = {}
default[:admin_group][:name] = "admin"
default[:admin_group][:guid] = "201"

users.each_key do |user|
  default[:users][user][:shell] = "/bin/bash"
end
