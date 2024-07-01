# WebDAV

[WebDAV](http://webdav.org/) is a set of extensions to the HTTP protocol which allows users to collaboratively edit and manage files on remote web servers.

> When application is installed and `Fix Permissions` is selected on at least 1 share
> a container will be launched with **root** privileges. This is required in order to apply
> the correct permissions to the selected `WebDAV` shares/directories.
> Afterward, the `WebDAV` container will run as a **non**-root user (Default: `568`).
> Note that `chown` will only apply if the parent directory does not match the configured user and group.
