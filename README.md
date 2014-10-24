Description
========

Installs Riak CS - an easy-to-use object storage software built on top of [Riak][1], Basho's distributed database.

Requirements
------------
Chef 11+

Usage
------

Include the riak-cs recipe in your run list:

```sh
knife node run_list add NODE "recipe[riak-cs::default]"
```

or add the riak-cs recipe as a dependency and include it from inside
another cookbook:

```ruby
include_recipe 'riak-cs::default'
```

The default settings will cause Riak to be installed and configured. All the config options exist in the `node['riak-cs']['config']` namespace and can be set to the appropriate Erlang data type with the methods : to_erl_string and to_erl_tuple . For more information see the [erlang_template_helper repository][6]

The default recipe installs open source Riak CS from a package. Debian, Ubuntu, Red Hat, and CentOS are installed via corresponding packagecloud repositories while any other platforms fetch packages directly from Basho's download site.

```ruby
# package.rb
node['riak_cs']['package']['version']['major'] = "1"
node['riak_cs']['package']['version']['minor'] = "5"
node['riak_cs']['package']['version']['incremental'] = "2"
```

### Enterprise Installation

To install Riak CS Enterprise populate the following attribute with a Basho
provided key:

```ruby
node['riak_cs']['package']['enterprise_key']
```

Stanchion
---------

Stanchion is an application that manages globally unique entities within a Riak CS cluster. It performs actions such as ensuring unique user accounts and bucket names across the whole system. **Riak CS cannot be used without Stanchion.** 

### Installation

The stanchion recipe is optional and will install Stanchion from a package. Debian, Ubuntu, Red Hat, and CentOS are installed via corresponding packagecloud repositories while any other platforms fetch packages directly from Basho's download site.

```ruby
# stanchion.rb
node['stanchion']['package']['version']['major'] = "1"
node['stanchion']['package']['version']['minor'] = "5"
node['stanchion']['package']['version']['incremental'] = "0"
```

License & Authors
--------------------
* Author: Sean Carey (<densone@basho.com>)
* Author: Seth Thomas (<cheeseplus@polycount.com>)
* Author: Hector Castro (<hector@basho.com>)

```text
Copyright (c) 2012-2014 Basho Technologies, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[1]: http://docs.basho.com/riak/latest/
