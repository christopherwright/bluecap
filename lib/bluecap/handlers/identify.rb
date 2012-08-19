module Bluecap
  class Identify

    attr_reader :name

    # Initialize an Identify handler.
    #
    # name - A String to uniquely identify the user from the source system.
    def initialize(name)
      @name = name
    end

    # Returns an id to track a user in Bluecap, creating an id if one does not
    # already exist.
    #
    # Examples
    #
    #   Bluecap::Identify.new('Andy').handle
    #   # => 1
    #
    #   Bluecap::Identify.new('Evelyn').handle
    #   # => 2
    #
    # Returns the Integer id.
    def handle
      id = Bluecap.redis.hget('user.map', @name)
      return id.to_i if id

      id = Bluecap.redis.incr('user.ids')
      if Bluecap.redis.hsetnx('user.map', @name, id)
        return id
      else
        # Race condition, another process has set the id for this user.
        # The unused id shouldn't cause inaccuracies in reporting since
        # the position will be 0 in all bitsets across the system.
        return redis.hget('user.map', @name).to_i
      end
    end

  end
end
