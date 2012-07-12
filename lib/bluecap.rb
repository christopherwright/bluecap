require 'eventmachine'
require 'redis'
require 'multi_json'

require 'bluecap/keys'
require 'bluecap/server'
require 'bluecap/handlers/attributes'
require 'bluecap/handlers/event'
require 'bluecap/handlers/identify'
require 'bluecap/handlers/report'

module Bluecap

  extend self

  # Connect to Redis and store the resulting client.
  #
  # server - A String of conncetion details in host:port format.
  #
  # Examples
  #
  #   redis = 'localhost:6379'
  #
  # Returns nothing.
  def redis=(server)
    host, port, database = server.split(':')
    @redis = Redis.new(host: host, port: port, database: database)
  end

  # Returns the Redis client, creating a new client if one does not already
  # exist.
  def redis
    return @redis if @redis
    self.redis = 'localhost:6379'
    self.redis
  end

end
