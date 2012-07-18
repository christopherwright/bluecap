require 'eventmachine'
require 'redis'
require 'multi_json'

require 'bluecap/keys'
require 'bluecap/message'
require 'bluecap/cohort'
require 'bluecap/engagement'
require 'bluecap/server'
require 'bluecap/handlers/attributes'
require 'bluecap/handlers/event'
require 'bluecap/handlers/identify'
require 'bluecap/handlers/null_handler'
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

  # Set the host to bind to.
  #
  # Returns nothing.
  def host=(host)
    @host = host
  end

  # Returns the String host to bind to.
  def host
    return @host if @host
    self.host = '0.0.0.0'
    self.host
  end

  # Set the port to bind to.
  #
  # Returns nothing.
  def port=(port)
    @port = port
  end

  # Returns the Integer port to bind to.
  def port
    return @port if @port
    self.port = 6088
    self.port
  end

  # Log a message to STDOUT.
  #
  # Returns nothing.
  def log(message)
    time = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    puts "#{time} - #{message}"
  end

end
