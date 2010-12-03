include_recipe "ruby"

package "libssl-dev"
package "rake"
package "libcurl4-openssl-dev"

gem_package "passenger" do
  version node[:passenger][:version]
end
