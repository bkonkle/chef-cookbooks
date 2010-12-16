default[:django][:version] = "1.2.3"
default[:django][:virtualenvs] = "#{sites[:dir]}/virtualenvs"
default[:django][:app_server] = "gunicorn"
