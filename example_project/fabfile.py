from os import sep
from os.path import join, realpath, dirname
from fabric.api import cd, env, local, run, sudo, require, settings
from fabric.contrib.project import rsync_project
from fabric.context_managers import hide
from fabric.operations import _prefix_commands, _prefix_env_vars

env.disable_known_hosts = True # always fails for me without this
env.root = '/opt/webapps/example_project'
env.proj_root = env.root + '/src/chef-cookbooks/example_project'
env.proj_repo = 'git@github.com:lincolnloop/chef-cookbooks.git'
env.pip_file = env.proj_root + '/requirements.pip'
env.chef_executable = '/var/lib/gems/1.8/bin/chef-solo'
env.cookbook_repo = 'git://github.com/lincolnloop/chef-cookbooks.git'
env.cookbook_rev = 'HEAD'
env.config_root = join(realpath(dirname(__file__)), 'config')

env.roledefs = {
    'dev': ['exampleproject'],
}

# Default to the dev role if no role was specified
if not env.get('roles') and not env.get('hosts'):
    env.roles = ['dev']


def deploy():
    """Update source, update pip requirements, syncdb, restart server"""
    update()
    update_reqs()
    syncdb()
    restart()


def switch(branch):
    """Switch the repo branch which the server is using"""
    with cd(env.proj_root):
        ve_run('git checkout %s' % branch)
    restart()


def version():
    """Show last commit to repo on server"""
    with cd(env.proj_root):
        sshagent_run('git log -1')


def restart():
    """Restart Apache process"""
    run('touch %s/etc/apache/django.wsgi' % env.root)


def update_reqs():
    """Update pip requirements"""
    ve_run('yes w | pip install -r %s' % env.pip_file)


def update():
    """Updates project source"""
    with cd(env.proj_root):
        sshagent_run('git pull')


def syncdb():
    """Run syncdb (along with any pending south migrations)"""
    ve_run('manage.py syncdb --migrate --noinput')


def clone():
    """Clone the repository for the first time"""
    with cd('%s/src' % env.root):
        sshagent_run('git clone %s' % env.proj_repo)
    ve_run('pip install -e %s' % env.proj_root)
    
    with cd('%s/myapp/conf/local' % env.proj_root):
        run('ln -s ../dev/__init__.py')
        run('ln -s ../dev/settings.py')


def sync_config():
    """
    Synchronizes the local configuration files to the server, and runs
    chef-solo to update the server.
    """
    rsync_project(remote_dir='~/.chefconfig/',
                  local_dir=env.config_root + sep, delete=True)
    sudo('rsync -az ~/.chefconfig/ /etc/chef/')
    sudo('sudo chown -R root:root /etc/chef/')
    with cd("/etc/chef/cookbooks"):
        sudo('git reset %s --hard && git pull' % env.cookbook_rev)
    
    sudo('%s -j /etc/chef/nodes/%s.json' % (env.chef_executable, env.host))


def bootstrap_chef():
    """
    Installs the necessary dependencies for chef-solo, and run an initial
    synchronization of the config.
    """
    with settings(user='root'):
        # Install the necessary packages
        run('apt-get update')
        run('apt-get -y dist-upgrade')
        run('apt-get install -y git-core rubygems ruby ruby-dev')
        run('gem install --no-rdoc --no-ri chef')
        
        # Copy the local configuration to the server
        rsync_project(remote_dir='/etc/chef/', local_dir=env.config_root + sep)
        
        with settings(warn_only=True):
            with hide('everything'):
                test_cookbook_dir = run('test -d /etc/chef/cookbooks')

        # If the /etc/chef/cookbooks directory already exists, then make
        # sure the cookbook repo is up to date.  Otherwise, clone it.
        if not test_cookbook_dir.return_code == 0:
            sshagent_run('git clone %s /etc/chef/cookbooks'
                         % env.cookbook_repo)
        
        with cd('/etc/chef/cookbooks'):
            sshagent_run('git reset %s --hard && git pull' % env.cookbook_rev)
        
        run('%s -j /etc/chef/nodes/%s.json' % (env.chef_executable, env.host))



def ve_run(cmd):
    """
    Helper function.
    Runs a command using the virtualenv environment
    """
    require('root')
    return sshagent_run('source %s/bin/activate; %s' % (env.root, cmd))


def sshagent_run(cmd):
    """
    Helper function.
    Runs a command with SSH agent forwarding enabled.

    Note:: Fabric (and paramiko) can't forward your SSH agent.
    This helper uses your system's ssh to do so.
    """
    # Handle context manager modifications
    wrapped_cmd = _prefix_commands(_prefix_env_vars(cmd), 'remote')
    try:
        host, port = env.host_string.split(':')
        return local(
            "ssh -p %s -A %s@%s '%s'" % (port, env.user, host, wrapped_cmd)
        )
    except ValueError:
        return local(
            "ssh -A %s@%s '%s'" % (env.user, env.host_string, wrapped_cmd)
        )
