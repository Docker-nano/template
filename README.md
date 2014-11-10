Nano template
=============

This is a template for building your own [Docker nano](https://github.com/Docker-nano) products using the provided
[Buildroot](http://buildroot.uclibc.org) container. You can also reuse this template later to update your products
after this template has received updates by merging in any changes.

Usage
-----

Using the template is as simple as cloning this source and inserting your product's name into a few files, replacing
the &lt;product> placeholders, as outlined in the following steps.

 1. Clone this repository (forking is for updating the template itself).
 2. Update `settings` with the name of your product.
    * `NANO_IMAGE` – The Buildroot image tag as listed in `docker images`.
    * `NANO_CONTAINER` – The Buildroot container name as listed in `docker ps`.
 3. Follow the [building](https://github.com/Docker-nano/Buildroot#building) instructions from the
    [Buildroot repository](https://github.com/Docker-nano/Buildroot) making sure to pull your config and rootfs
    afterwards.
 4. Add your name and email address to `Dockerfile` and uncomment the `COPY` line. Rebuild the image to ensure it still
    works.
 5. Add your name and email address to `product/Dockerfile` and any other build steps required to configure your
    product.
 6. Build your product with `docker build -t nano/<product> product`.
 7. Test it with `docker run -it --rm nano/<product>` or similar.
 8. Update `.travis.yml` test to check for the presence of your binary in the rootfs.
 9. Replace this readme with the distributed one (`mv README.md.dist README.md`).
 10. Update `README.md` and `product/README.md` so others know how to use your product.
 11. Tell us! Get in touch with a member of the [Docker nano team](https://github.com/orgs/Docker-nano/people) so we
     can add your product to the registry for others to use.

Following is information for advanced modifications that may be required.

Patching Buildroot
------------------

If you wish to make changes to Buildroot you can either copy files into place or create a patch by following the steps
below. Prefer copying if you're adding new files and patching if you're changing existing files, so it's clear which
changes have been made.

 1. Copy the file – `cp -bf file{,}`.
 2. Edit the file – `editor file`.
 3. Create the patch – `diff -u file~ file > file.patch`.
 4. Edit the patch header. A typical patch header may look like the following.

    ```
    --- file~    1970-01-01 00:00:00.123456789 +0000
    +++ file     1970-01-01 00:00:00.123456789 +0000
    @@ -1,0 +1,1 @@
    +foo
    ```

    Nano patches are applied in the context of the Buildroot source directory (`~/buildroot`) so if you are patching
    `file` of the `foobar` package then the relative path should be inserted into the patch header. The first line and
    time information should be removed. After editing the modified patch file may look similar to the following.

    ```
    +++ package/foobar/file
    @@ -1,0 +1,1 @@
    +foo
    ```

 5. Copy your patches to `in/patches` on the host.
 6. Uncomment the patching directives in the `Dockerfile` template.
 7. Build your container and ensure the patches are applied correctly.

Modifying the rootfs
--------------------

If you wish to add to or overwrite files in the rootfs image simply add those files to `in/rootfs_overlay` and add
`COPY in/rootfs_overlay /root/buildroot/rootfs_overlay` to your `Dockerfile`. Buildroot is already configured to pick
up files in this directory and merge them into the rootfs using the directory structure you provide in the overlay
directory.

To remove files modify the `post_build.sh` script. The post-build script is configured to run in the context of the
rootfs directory. New instructions should be appended to the existing script by modifying the `Dockerfile`, for
example, `RUN echo rm -r var/run >> buildroot/post_build.sh` will remove `/var/run` from the rootfs. Don't forget to
update `.travis.bash` with the same commands to modify `post_build.sh`.

For more information see
[customizing the generated target filesystem](http://buildroot.uclibc.org/downloads/manual/manual.html#rootfs-custom).
