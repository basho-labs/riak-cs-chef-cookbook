require File.expand_path("../support/helpers", __FILE__)

describe "riak-cs::control" do
  include Helpers::RiakCS

  it "installs riak-cs-control" do
    package("riak-cs-control").must_be_installed
  end

  it "runs a service named riak-cs-control" do
    service("riak-cs-control").must_be_running
  end

  it "responds to riak-cs-control ping" do
    assert(`riak-cs-control ping` =~ /pong/)
  end
end
