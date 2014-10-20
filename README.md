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
5. Add your name and email address to `product/Dockerfile` and any other build steps required to configure your product.
6. Build your product with `docker build -t nano/<product> product`.
7. Test it with `docker run -it --rm nano/<product>` or similar.
8. Update `.travis.yml` test to check for the presence of your binary in the rootfs.
9. Replace this readme with the distributed one (`mv README.md.dist README.md`).
10. Update `README.md` and `product/README.md` so others know how to use your product.
11. Tell us! Get in touch with a member of the [Docker nano team](https://github.com/orgs/Docker-nano/people) so we can
    add your product to the registry.
