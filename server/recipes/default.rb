# The base recipe for servers.

include_recipe "users"
include_recipe "sudo"

BASE_PACKAGES = ["git-core", "bash-completion", "emacs23-nox", "postfix",
                 "bsd-mailx", "build-essential", "python-software-properties",
                 "ntp"]

case node[:platform]
when "ubuntu", "debian"
  execute "update-locale" do
    command "update-locale LANG=en_US.UTF-8 && export LANG=en_US.UTF-8"
    not_if 'test $LANG = "en_US.UTF-8"'
  end
end

BASE_PACKAGES.each do |pkg|
  package pkg do
    action :upgrade
  end
end

if node.attribute?("hosts")
  template "/etc/hosts" do
    source "hosts.erb"
    mode 644
    variables :hosts => node[:hosts] || {}
  end
end
