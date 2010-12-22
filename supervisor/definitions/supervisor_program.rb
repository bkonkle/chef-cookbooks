define :supervisor_program, :autostart => true do
  include_recipe "supervisor"
  
  if params[:exitcodes]
    exitcodes = params[:exitcodes].join(",")
  else
    exitcodes = nil
  end

  if params[:environment]
    envsettings = []
    params[:environment].each_pair do |key, value|
      envsettings.push("#{key}=#{value}")
    end
    environment = envsettings.join(",")
  else
    environment = nil
  end
  
  template "/etc/supervisor/conf.d/#{params[:name].conf}" do
    source "program.conf.erb"
    user "root"
    group "root"
    mode "0644"
    variables :name => params[:name],
      :command => params[:command],
      :directory => params[:directory],
      :user => params[:user],
      :autostart => params[:autostart],
      :autorestart => params[:autorestart],
      :exitcodes => exitcodes,
      :startretries => params[:startretries],
      :environment => environment,
      :stdout_logfile => params[:stdout_logfile],
      :stderr_logfile => params[:stderr_logfile],
      :redirect_stderr => params[:redirect_stderr],
      :stopsignal => params[:stopsignal]
    notifies :reload, resources(:service => "supervisor")
  end
end
