require File.expand_path("../support/helpers", __FILE__)

describe "riak-cs::default" do
  include Helpers::RiakCS

  it "installs riak-cs" do
    package(node["riak_cs"]["package"]["enterprise_key"].empty? ? "riak-cs" : "riak-cs-ee").must_be_installed
  end

  it "runs a service named riak-cs" do
    service("riak-cs").must_be_running
  end

  it "responds to riak-cs ping" do
    assert(`riak-cs ping` =~ /pong/)
  end
end
