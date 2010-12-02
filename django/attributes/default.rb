include_attribute "server"

default[:django][:virtualenvs] = "#{sites[:dir]}/.virtualenvs"
default[:django][:app_server] = "gunicorn"
default[:django][:sites] = {}
