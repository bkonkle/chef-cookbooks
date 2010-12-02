PACKAGES = ["python-setuptools", "python-pip", "python-dev"]
PIP_PACKAGES = {"virtualenv" => "1.5.1"}

PACKAGES.each do |pkg|
  package pkg do
    action :upgrade
  end
end

PIP_PACKAGES.each_pair do |pkg, ver|
  pip_package pkg do
    action :install
    version ver
  end
end
