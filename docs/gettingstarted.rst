Getting Started
===============

This project was created with Chef Solo in mind, so certain optimizations like
search are not utilized.  These cookbooks should still run smoothly on Chef
client/server, though.  They are primarily for Django and Rails sites, and
should be suitable for both small one-server projects or large multi-server
deployments.

To use these cookbooks, you will create some site-specific configuration
files in your project's source control.  These will usually include nodes,
roles, and a site-cookbook for your site.  These site-specific files will
work with the modular cookbooks here to fully provision your servers.

First Steps
***********


