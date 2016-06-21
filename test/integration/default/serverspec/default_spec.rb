require 'spec_helper'

describe 'cb-reverse-proxy::default' do
  describe command('curl -k --head http://localhost/bing/search?q=hello') do
    its(:stdout) { should match /Location: http:\/\/www.bing.com\// }
    its(:exit_status) { should eq 0 }
  end

  describe command('curl -k --head http://localhost/weather/today/l/USGA0028:1:US') do
    its(:stdout) { should match /Location: https:\/\/www.weather.com\/weather\/today\/l\/USGA0028:1:US/ }
    its(:exit_status) { should eq 0 }
  end

  describe command('sysctl net.ipv4.ip_local_port_range') do
    its(:stdout) { should contain('20000') }
    its(:stdout) { should contain('64000') }
    its(:exit_status) { should eq 0 }
  end

end
