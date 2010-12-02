# The base recipe for servers.

include_recipe "users"
include_recipe "sudo"

BASE_PACKAGES = ["git-core", "bash-completion", "emacs23-nox", "postfix",
                 "bsd-mailx", "build-essential", "python-software-properties"]

execute "update-locale" do
  command "update-locale LANG=en_US.UTF-8 && export LANG=en_US.UTF-8"
  not_if 'test $LANG = "en_US.UTF-8"'
end

BASE_PACKAGES.each do |pkg|
  package pkg do
    action :upgrade
  end
end

if node.attribute?("all_servers")
  template "/etc/hosts" do
    source "hosts.erb"
    mode 644
    variables :all_servers => node[:all_servers] || {}
  end
end
