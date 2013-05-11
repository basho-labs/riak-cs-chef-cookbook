require File.expand_path("../support/helpers", __FILE__)

describe "riak-cs::stanchion" do
  include Helpers::RiakCS

  it "installs stanchion" do
    package("stanchion").must_be_installed
  end

  it "runs a service named stanchion" do
    service("stanchion").must_be_running
  end

  it "responds to stanchion ping" do
    assert(`stanchion ping` =~ /pong/)
  end
end
