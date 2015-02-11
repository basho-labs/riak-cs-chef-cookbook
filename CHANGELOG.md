## v2.2.11

* Riak CS `1.5.4` is now the default
* Update Gemfile dependencies

## v2.2.10

* Fix incremental package version attribute

## v2.2.9

* Riak CS 1.5.2 is now the default

## v2.2.8

* Riak CS `1.5.1` is now the default
* Riak `1.4.10` is now the default
* Update yum dependency to resolve GPG key issues
* Add digitalocean to `.kitchen.cloud.yml`

## v2.2.7:

* Add support for Amazon Linux.

## v2.2.6:

* Riak `1.4.8` is now the default.
* Riak CS `1.4.5` is now the default.
* Updated yum dependency constraint.
* Make all cookbook dependency versions explicit.
* Ensure /etc/default/riak is regenerated when open file limits change.

## v2.2.5:

* Riak `1.4.7` is now the default.
* Make use of `vagrantfile_erb` setting of kitchen-vagrant.

## v2.2.4:

* Riak CS `1.4.3` is now the default.
* Bumped Chef to version `11.8.0` for Test Kitchen.
* Fix invalid `cs_version`.

## v2.2.3:

* Add Debian Wheezy to Test Kitchen suite.
* Riak CS `1.4.1` is now the default.
* Riak CS Control `1.0.2` is now the default.

## v2.2.2:

* Riak `1.4.2` is now the default.
* Remove `allow_mult` overrides in Test Kitchen suite.
* Fixed the `remote_file` resource for Enterprise packages so that it utilizes
  a checksum.
* Update Riak CS attribute defaults for `1.4+`.
* Made Test Kitchen run faster by enabling the `vagrant-cachier` plugin
  through the `kitchen-vagrant` driver.

## v2.2.1:

* Add support for installing older versions of Riak CS.

## v2.2.0:

* Riak CS `1.4.0` is now the default.
* Add support for Riak CS Enterprise.

## v2.1.0:

* Standardize file descriptor limit setting procedures so that they line up
  with the Riak cookbook.
* Allow package installation to take advantage of Basho's APT and RPM
  repositories.
* Switch to provisionerless Vagrant boxes for Test Kitchen.

## v2.0.0:

* Broke cookbook version scheme away from Riak CS.
* Add support for Riak CS Control.
