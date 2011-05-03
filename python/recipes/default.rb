%w{python-setuptools python-dev}.each do |pkg|
  package pkg do
    action :upgrade
  end
end

easy_install_package "pip"
pip_package "virtualenv"
