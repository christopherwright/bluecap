require 'redis'

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
