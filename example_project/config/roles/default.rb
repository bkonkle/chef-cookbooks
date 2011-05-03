name 'default'
description 'Default role.'

run_list "recipe[myapp]"

default_attributes "hosts" => {
    "exampleproject" => {
      "external_ip" => "50.56.29.89",
      "internal_ip" => "10.181.227.77"
    }
  },
  
  # Database settings
  "postgresql" => {
    "server_root_password" => "sdjfh34trfj"
  },
  
  # Application settings
  "application" => {
    "domain" => "dev.myproject.com",
    "virtualenv" => "/opt/webapps/example_project",
    "dbname" => "example_project"
  },
  
  # User settings
  "users" => {
    "myuser" => {
      "full_name" => "My User",
      "groups" => ["admin"],
      "ssh_keys" => <<-SSHKEYS,
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1M+qcLu2gjcqky6WPqjB5/XQ31j/iJA1WO7hLrIJ+M88Oc29rLzBOpjLtOD4PbIm83aMJ2weFwdEf0oM+Zb3VsNIgrq1ZsJJQu5MnXWyS+RU3pXw0jNo9a80vEKjjG6f4vTR8YRy4W9YqNayGGpi2oHbvbCy32m2X+DMkqbYkB9vrJ8V+NTt4gpnqwjlP8LSzIKSmD3ZSuqt5qeA4ys+O+PYYpRK9grpczEjzcFZ6r4jhcyU45+3yIL5Peti6+bnIkEDQArO/+sIROSUBUQAeQsu7GbqIgLerOA93RqbH7weg7N/hi/mYxpcHoaQg3Ic1kdYvc5/Z/eLxdo/5PPnUQ== brandon@brandonkonkle.com
SSHKEYS
      "known_hosts" => <<-KNOWNHOSTS,
# The 2 lines below are for Github
|1|Dst7mFzjY0EHw8TAH5Nex1zazkk=|RxuJRJeP+67DHpXqbdVZwUyQMo4= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|XeNMOWERxlFocwZvuoklfzksYis=|85YCezd9rVsLkVnm24FcMv4Iqs4= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
KNOWNHOSTS
    },
  }
