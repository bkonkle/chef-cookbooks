import os, sys
import site

site.addsitedir('/opt/webapps/example_project/lib/python2.6/site-packages')


sys.stdout = sys.stderr

os.environ['DJANGO_SETTINGS_MODULE'] = 'myapp.conf.dev.settings'

import django.core.handlers.wsgi

application = django.core.handlers.wsgi.WSGIHandler()
