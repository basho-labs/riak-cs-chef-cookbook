site :opscode

metadata

group :integration do
  cookbook "apt"
  cookbook "yum", "~> 3.0"
  cookbook "yum-epel", "~> 0.3"
  cookbook "minitest-handler"

  cookbook "riak", github: "basho/riak-chef-cookbook", ref: "2.4.7"
  cookbook "riak-cs-create-admin-user", github: "hectcastro/chef-riak-cs-create-admin-user", ref: "0.3.1"
end
