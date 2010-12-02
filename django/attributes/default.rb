include_attribute "server"

default[:django][:virtualenvs] = "#{sites[:dir]}/.virtualenvs"
default[:django][:sites] = {}
