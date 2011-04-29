Next Steps
==========

Roles
-----

The next step in a basic configuration is the definition of roles. Roles
describe your application servers, load balancers, utility servers, database
servers, etc. Instead of defining things like your users and groups in your
node config, you'll want to set this up in your roles.

The Default Role
****************

The first role you'll want to create is your default role, which will handle
configuration that you want to be uniform across all of your nodes.  This often
includes things like an admin group, or a deploy user.

Create a directory called *roles* inside of *config*.  Then create a
*default.rb* file inside the folder that looks like this:

.. code-block:: ruby

    name 'default'
    description 'Default role for myapp servers.'
    run_list "recipe[server]"
    
    default_attributes "hosts" => {
        "myloadbalancer" => {
          "external_ip" => "123.45.67.89",
          "internal_ip" => "10.0.1.101"
        },
        "myappserver" => {
          "external_ip" => "123.45.67.90",
          "internal_ip" => "10.0.1.102"
        },
        "mydbserver" => {
          "external_ip" => "123.45.67.91",
          "internal_ip" => "10.0.1.103"
        }
      },
      
      # Settings for the sites directory
      "sites" => {
        "user" => "myuser"
      },

      # User settings
      "users" => {
        "myuser" => {
          "full_name" => "My User",
          "groups" => ["admin"],
          "ssh_keys" => <<-SSHKEYS,
    ssh-rsa AAAAB3NzaC1y...xdo/5PPnUQ== my@developer.com
    ssh-rsa AAAAB3NzaC1y...flF7RVqcOw== my@other-developer.com
    SSHKEYS
          "known_hosts" => <<-KNOWNHOSTS,
    |1|Dst7mFzjY0EHw8TAH5Nex1zazkk=|RxuJRJeP+67DHpXqbdVZwUyQMo4= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
    |1|XeNMOWERxlFocwZvuoklfzksYis=|85YCezd9rVsLkVnm24FcMv4Iqs4= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
    KNOWNHOSTS
          "id_rsa_pub" => "ssh-rsa AAAAB3NzaC1y...6BBykJ/Q== server@myapp.com",
          "id_rsa" => <<-RSAKEY
    -----BEGIN RSA PRIVATE KEY-----
    R5kEi5fP2fXRHsrf7erjT5CTkSCD1/+1Wnf9Rg2n69U+ustph2ETYgZ+cAWeju56
    zKgbXhSwIWNVgHu3S0WnsxfOJH9IOG25/pdj4sUfMuqUNcWhNbhJmF0z15j4EulZ
    ...
    xgI3mkBqDlYZkvgoWEeZFiwVXS9T4PR1em0aExKlTpDsg+JL/oNNDn4+FzwlJzgY
    9B2iSVH0QAasA0tj1Z/34otxSBY7I5SFVK+Wjk28YIfmMCwxS1T7pz5HzNCabjce
    z89bOyUOj2hV347yM3sYIe5f4WQgeG
    -----END RSA PRIVATE KEY-----
    RSAKEY
        },
      }

Let's break this apart and look at it piece by piece.

.. code-block:: ruby
    
    run_list "recipe[server]"

    default_attributes "hosts" => {
        "myloadbalancer" => {
          "external_ip" => "123.45.67.89",
          "internal_ip" => "10.0.1.101"
        },
        "myappserver" => {
          "external_ip" => "123.45.67.90",
          "internal_ip" => "10.0.1.102"
        },
        "mydbserver" => {
          "external_ip" => "123.45.67.91",
          "internal_ip" => "10.0.1.103"
        }
      },

The 'run_list' at the top indicates that we want to run the ``server`` recipe.
The 'default_attributes' call defines a data structure that established some
default values that can be overriden by other roles. The first section is
"hosts", which is handled by the ``server`` recipe. It creates a new
*/etc/hosts* file containing the necessary definitions so that your servers
know how to reach each other.

.. code-block:: ruby

    # Settings for the sites directory
    "sites" => {
      "user" => "myuser"
    },
    
This will create a directory to hold your sites (located by default under
/sites/).  It will set "myuser" as the owner.  Right now, this attribute is
handled by the ``nginx`` recipe, but this may change in the future.  If you
omit this attribute, then the directory will still be created by the Nginx
recipe (if you include it, which we'll cover later), and the owner will default
to 'root'.

.. code-block:: ruby

    # User settings
    "users" => {
      "myuser" => {
        "full_name" => "My User",
        "groups" => ["admin"],

The "users" attribute is handled by the ``users`` recipe (what a surprise!).
In this case, a user will be created with the username "myuser".  Any group
added to any user in this attribute will cause that group to be created
automatically by the ``users`` recipe.

.. code-block:: ruby

          "ssh_keys" => <<-SSHKEYS,
    ssh-rsa AAAAB3NzaC1y...xdo/5PPnUQ== my@developer.com
    ssh-rsa AAAAB3NzaC1y...flF7RVqcOw== my@other-developer.com
    SSHKEYS
          "known_hosts" => <<-KNOWNHOSTS,
    |1|Dst7mFzjY0EHw8TAH5Nex1zazkk=|RxuJRJeP+67DHpXqbdVZwUyQMo4= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
    |1|XeNMOWERxlFocwZvuoklfzksYis=|85YCezd9rVsLkVnm24FcMv4Iqs4= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
    KNOWNHOSTS

The "ssh_keys" and "known_hosts" blocks use a Ruby notation called "here doc"
to define values for the *authorized_keys* and *known_hosts* placed within the
user's *~/.ssh/* directory.

.. code-block:: ruby

          "id_rsa_pub" => "ssh-rsa AAAAB3NzaC1y...6BBykJ/Q== server@myapp.com",
          "id_rsa" => <<-RSAKEY
    -----BEGIN RSA PRIVATE KEY-----
    R5kEi5fP2fXRHsrf7erjT5CTkSCD1/+1Wnf9Rg2n69U+ustph2ETYgZ+cAWeju56
    zKgbXhSwIWNVgHu3S0WnsxfOJH9IOG25/pdj4sUfMuqUNcWhNbhJmF0z15j4EulZ
    ...
    xgI3mkBqDlYZkvgoWEeZFiwVXS9T4PR1em0aExKlTpDsg+JL/oNNDn4+FzwlJzgY
    9B2iSVH0QAasA0tj1Z/34otxSBY7I5SFVK+Wjk28YIfmMCwxS1T7pz5HzNCabjce
    z89bOyUOj2hV347yM3sYIe5f4WQgeG
    -----END RSA PRIVATE KEY-----
    RSAKEY
        },
      }

If you'd like, you can also define "id_rsa" attributes so that you can give
your user its own public/private key pair.

Targeted Roles
**************

Typically, however, you won't point a node to the default role. You'll want to
create job-specific roles that include the default role.  Let's set up a web
server that uses Nginx next.  Create a file called *web.rb* in your *roles*
directory.

.. code-block:: ruby

    name 'web'
    description 'A web server that handles requests using Nginx.'
    run_list "role[default]", "recipe[nginx]"
    
This role will read the default role, which runs the ``server`` recipe with
the configuration provided.  Then it will run the ``nginx`` recipe, which
installs the standard Nginx package.

Now, we need to point our node to this role.  Under your *nodes* directory,
find the appropriate node and make it look like this:

.. code-block:: js

    {"name": "mywebserver", "run_list": "role[web]"}

Site Cookbooks
--------------

At this point, you're probably wanting to create a site config for Nginx.  You
will also want to put a page up for Nginx to serve.  For this, you'll want to
begin a site cookbook.  This is where you'll get into the really specific
details about your configuration, and is likely where the bulk of your code
will be.

To create a site cookbook, create a *site-cookbooks* directory underneath
*config*.  Then, create a cookbook folder with a name like *mysite* inside.

Recipes
*******

The first thing you'll want to do is create a recipe inside your cookbook.
Create a *recipes* folder inside your cookbook folder.  Create a recipe called
*web.rb* that looks like this:

.. code-block:: ruby

    include_recipe "nginx"
    
    nginx_site "mysite" do
      template "nginx/mysite.conf.erb"
      action :enable
    end

This will create a site config under */etc/nginx/sites-available*, and then
symlink it into *sites-enabled*.

Templates
*********

If you run the sync just like that, however, it will fail. You need to create
the template that the definition above alludes to. Create a directory inside
your cookbook folder called *templates*. Underneath that, create a directory
called *default*.

There, you can create an *erb* template for your Nginx site config.  This is
done in *erb* format so that you can insert data from your attributes later.
Create a directory called *nginx* under *default*, and then a file called
*mysite.conf.erb* that looks like this:

.. code-block:: nginx

    server {
      listen 80;
      server_name mysite.com;
  
      root /var/www/construction;
    }

This will most likely just be a static "Under construction" landing page, since
we're not ready to start using a dynamic framework like Django or Rails yet.
Because of this, I'm pointing the site to an arbitrary construction page
location.

Directories and Files
*********************

Next, we'll briefly dive into basic Chef config territory to take you the rest
of the way to getting the landing page up.  In your *web.rb* recipe, add the
following lines:

.. code-block:: ruby

    directory "/var/www/construction" do
      owner "www-data"
      group "sdmin"
      mode "0755"
    end
    
    cookbook_file "/var/www/construction/index.html" do
      source "index.html"
      owner "www-data"
      group "admin"
      mode "0644"
    end
    
Now, add create a folder underneath your *mysite* cookbook called *files*.
Inside, create a *default* folder, and then an *index.html* file.  Add to this
file what you wish.

This will create the */var/www/construction* directory on your server, and
copy the *index.html* file to it.  From this point, you should be ready to run
the sync, access your server, and marvel at your delightful landing page.
