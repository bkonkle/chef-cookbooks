Chef Cookbooks
==============

A set of cookbooks to use Chef for managing configuration for Django on Ubuntu
servers.  Many of these cookbooks came from the [Opscode repository][1], but
they have been heavily modified.  Some of the ideas came from Eric Holscher's
great [blog posts][2] about using Chef with Django.

These cookbooks are designed to be used to handle everything except for the
deployment, which can be handled with a separate tool like Fabric.  In the
future, these cookbooks will likely be updated to take advantage of Chef's
*deploy* resource to manage the checkout of the code as well.

Read the documentation [here][3].

[1]: https://github.com/opscode/cookbooks
[2]: http://ericholscher.com/blog/2010/nov/8/building-django-app-server-chef/
[3]: http://lincolnloop.github.com/chef-cookbooks/