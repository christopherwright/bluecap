require 'bluecap'

dir = File.dirname(File.expand_path(__FILE__))

RSpec.configure do |config|
  config.before(:suite) do
    puts 'Starting redis test server'
    `redis-server #{dir}/redis-test.conf`
    Bluecap.redis = 'localhost:6330'
  end

  config.after(:suite) do
    puts '', 'Killing redis test server'
    pids = `ps -ef | grep [r]edis-test`.split('\n').map { |p| p.split(' ')[1] }
    pids.each { |pid| Process.kill('KILL', pid.to_i) }
    `rm -f #{dir}/dump.rdb`
  end
end

