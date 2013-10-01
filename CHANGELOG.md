## v2.2.4:

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
