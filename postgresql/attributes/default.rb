default[:postgresql][:version] = "8.4"

case platform
when "debian"
  
  # If Lenny or below, use 8.3
  if platform_version.to_f <= 5.0
    default[:postgresql][:version] = "8.3"
  end

when "ubuntu"

  # If Jaunty or below, use 8.3
  if platform_version.to_f <= 9.04
    default[:postgresql][:version] = "8.3"
  end

end
