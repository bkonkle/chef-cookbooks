%w{postgresql-client libpq-dev}.each do |pkg|
  p = package pkg do
    action :nothing
  end
  p.run_action(:install)
end

g = gem_package "pg" do
  action :nothing
end

g.run_action(:install)

Gem.clear_paths
require "pg"
