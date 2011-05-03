%w{python-setuptools python-pip python-dev}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

pip_package "pip" do
  action :upgrade
end

pip_package "virtualenv"
