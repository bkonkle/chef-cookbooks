groups = Hash.new

node[:users].each_pair do |name, info|
  shell = (info[:shell] or "/bin/bash")
  
  info[:groups].each do |group|
    if groups[group]
      unless groups[group].include?(name)
        groups[group] = groups[group].push(name)
      end
    else
      groups[group] = [name]
    end
  end
  
  home_dir = "/home/#{name}"

  user name do
    uid info[:uid]
    gid info[:uid]
    shell shell
    comment info[:full_name]
    supports :manage_home => true
    home home_dir
  end
  
  group name do
    gid info[:uid]
  end

  directory "#{home_dir}/.ssh" do
    owner name
    group info[:gid] || name
    mode "0700"
  end

  file "#{home_dir}/.ssh/authorized_keys" do
    content info[:ssh_keys]
    owner name
    group info[:gid] || name
    mode "0600"
  end
  
  file "#{home_dir}/.ssh/known_hosts" do
    content info[:known_hosts]
    owner name
    group info[:gid] || name
    mode "0644"
  end
  
  file "#{home_dir}/.ssh/id_rsa" do
    content info[:id_rsa]
    owner name
    group info[:gid] || name
    mode "0600"
  end
  
  file "#{home_dir}/.ssh/id_rsa.pub" do
    content info[:id_rsa_pub]
    owner name
    group info[:gid] || name
    mode "0644"
  end
  
  template "#{home_dir}/.profile" do
    source "profile.erb"
    owner name
    group info[:gid] || name
    mode "0644"
  end

  template "/home/#{name}/.bashrc" do
    source "bashrc.erb"
    owner name
    group info[:gid] || name
    mode "0644"
  end

  template "/home/#{name}/.bash_logout" do
    source "bash_logout.erb"
    owner name
    group info[:gid] || name
    mode "0644"
  end
end

node[:groups].each_pair do |name, group|
  group name do
    gid group[:gid]
    members groups[name]
  end
end

admin_group = node[:admin_group][:name]
if groups.has_key?(admin_group)
  group admin_group do
    gid node[:admin_group][:group]
    members groups[admin_group]
  end
end