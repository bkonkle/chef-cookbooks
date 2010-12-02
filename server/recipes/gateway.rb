include_recipe "server::default"

if node.attribute?("rails")
  if node[:rails][:app_server] == "passenger"
    include_recipe "passenger"
  end
end
