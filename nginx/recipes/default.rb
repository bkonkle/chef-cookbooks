# Used for when you just want the plain Nginx package

package "nginx" do
  version node[:nginx][:version]
end

include_recipe "nginx::base"
