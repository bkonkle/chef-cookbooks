groups = Hash.new

node[:users].each_pair do |username, user|
  shell = (user[:shell] or "/bin/bash")
  
  user[:groups].each do |group|
    if groups[group]
      unless groups[group].include?(username)
        groups[group] = groups[group].push(username)
      end
    else
      groups[group] = [username]
    end
  end
  
  home_dir = "/home/#{username}"

  user username do
    uid user[:uid]
    gid user[:uid]
    shell shell
    comment user[:full_name]
    supports :manage_home => true
    home home_dir
  end
  
  group username do
    gid user[:uid]
  end

  directory "#{home_dir}/.ssh" do
    owner username
    group user[:gid] || username
    mode "0700"
  end

  file "#{home_dir}/.ssh/authorized_keys" do
    content user[:ssh_keys]
    owner username
    group user[:gid] || username
    mode "0600"
  end
  
  file "#{home_dir}/.ssh/id_rsa" do
    content user[:id_rsa]
    owner username
    group user[:gid] || username
    mode "0600"
  end
  
  file "#{home_dir}/.ssh/id_rsa.pub" do
    content user[:id_rsa_pub]
    owner username
    group user[:gid] || username
    mode "0644"
  end
  
  cookbook_file "#{home_dir}/.profile" do
    source "profile"
    owner username
    group user[:gid] || username
    mode "0644"
  end

  cookbook_file "/home/#{username}/.bashrc" do
    source "bashrc"
    owner username
    group user[:gid] || username
    mode "0644"
  end

  cookbook_file "/home/#{username}/.bash_logout" do
    source "bash_logout"
    owner username
    group user[:gid] || username
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