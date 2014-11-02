require 'spec_helper'

describe service('collectdmon') do  
  it { should be_running   }
end 

describe command("ls /var/lib/collectd/rrd") do
  it { should return_stdout /10\.0\.2\.15/ }
end
