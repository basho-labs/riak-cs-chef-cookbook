require 'delegate'
module CSTemplateHelper
  class Tuple < DelegateClass(Array)
    include CSTemplateHelper
    def to_s
      "{" << map {|i| value_to_erlang(i) }.join(", ") << "}"
    end
  end

  def value_to_erlang(v, depth=1)
    case v
    when Hash
      erlang_config(v, depth+1)
    when String
      "\"#{v}\""
    when Array
      "[" << v.map {|i| value_to_erlang(i) }.join(", ") << "]"
    else
      v.to_s
    end
  end

  # Lifted from Ripple's Riak::TestServer
  def erlang_config(hash, depth = 1)
    padding = '    ' * depth
    parent_padding = '    ' * (depth-1)
    values = hash.map do |k,v|
      if KEYLESS_ATTRIBUTES.include?(k)
        #We make the assumption that all KEYLESS_ATTRIBUTES are arrays. 
        Tuple.new(v).to_s
      elsif TUPLE_IN_TUPLE.include?(k)
        "{#{k},{#{v[0]},#{v[1]}}}"
      else
        "{#{k}, #{value_to_erlang(v, depth)}}"
      end
    end.join(",\n#{padding}")
    "[\n#{padding}#{values}\n#{parent_padding}]"
  end
  
  #There are several configurations that are not key/value. They should be added to KEYLESS_ATTRIBUTES. 
  #A sample of this wold be the lager configuration. 
  #{"{{platform_log_dir}}/error.log", error, 10485760, "$D0", 5}
  KEYLESS_ATTRIBUTES = ['lager_error_log','lager_console_log']
  TUPLE_IN_TUPLE = ['riakc_pool']
  
  #Remove these configs. This will make sure package and erlang vms are not processed into the riak app.config. 
  CS_REMOVE_CONFIGS = ['package', 'erlang']
  
  def process_app_config(cs)
    # Don't muck with the node attributes
    cs = cs.to_hash

    # Remove sections we don't care about
    cs.reject! {|k,_| CS_REMOVE_CONFIGS.include? k }

    # Return the sanitized config
    cs
  end

  CS_VM_ARGS = {
    "node_name" => "-name",
    "cookie" => "-setcookie",
    "heart" => "-heart",
    "kernel_polling" => "+K",
    "async_threads" => "+A",
    "error_logger_warnings" => "+W",
    "env_vars" => "-env"
  }
    
  def setup_vm_args(config)
    config.map do |k,v|
      key = CS_VM_ARGS[k.to_s]
      case v
      when false
        nil
      when Hash
        # Mostly for env_vars
        v.map {|ik,iv| "#{key} #{ik} #{iv}" }
      else
        "#{key} #{v}"
      end
    end.flatten.compact
  end
end

class Chef::Resource::Template
  include CSTemplateHelper
end

class Erubis::Context
  include CSTemplateHelper
end
