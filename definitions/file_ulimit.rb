define :file_ulimit,
       :hard_limit => 1024,
       :priority => 95 do

  params[:user] ||= params[:name]
  params[:soft_limit] ||= params[:hard_limit]

  case node['platform']
  when "ubuntu"
    ulimit_conf_file = "/etc/default/#{params[:name]}"
    template_name = "default_file_limit.erb"
  when "centos", "redhat", "fedora"
    ulimit_conf_file = "/etc/security/limits.d/#{params[:priority]}-#{params[:name]}.conf"
    template_name = "user_file_ulimit.erb"
  end

  template ulimit_conf_file do
    source template_name
    cookbook "riak-cs"
    owner "root"
    group "root"
    mode 0644
    variables(
      :user => params[:user],
      :soft_limit => params[:soft_limit],
      :hard_limit => params[:hard_limit]
    )
  end

end
