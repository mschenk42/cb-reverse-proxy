#
# Cookbook Name:: cb-reverse-proxy
# Recipe:: default
#

apt_update 'all platforms' do
  frequency 86400
  action :periodic
end

package ['curl', 'nginx']  do
  action :install
end

template '/etc/nginx/sites-available/revproxy' do
  source 'revproxy.erb'
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
end

link '/etc/nginx/sites-enabled/revproxy' do
  to '/etc/nginx/sites-available/revproxy'
  action :create
end

ruby_block 'extend the ephemeral port range' do
  block do
    fe = Chef::Util::FileEdit.new("/etc/sysctl.conf")
    fe.insert_line_if_no_match(/net.ipv4.ip_local_port_range = 20000 64000/,
                               "net.ipv4.ip_local_port_range = 20000 64000")
    fe.write_file
  end
end

execute 'sysctl reload' do
  command 'sysctl -p'
end

service 'nginx' do
  action :restart
end
