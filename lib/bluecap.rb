require 'eventmachine'
require 'redis'
require 'multi_json'

require 'bluecap/server'
require 'bluecap/handlers/event'
require 'bluecap/handlers/identify'
require 'bluecap/handlers/report'

module Bluecap
  extend self

  def redis=(server)
    host, port, database = server.split(':')
    @redis = Redis.connect(host: host, port: port, database: database)
  end

  def redis
    return @redis if @redis
    self.redis = 'localhost:6379'
    self.redis
  end
end
