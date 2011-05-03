from django.conf.urls.defaults import patterns, url, include
from django.views.generic.simple import redirect_to

urlpatterns = patterns('',
    (r'^$', redirect_to, {'url': '/admin/'}),
)
