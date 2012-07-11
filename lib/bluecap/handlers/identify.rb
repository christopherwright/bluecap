module Bluecap
  class Identify

    # Returns an id to track a user in Bluecap, creating an id if one does not
    # already exist.
    #
    # data - A Hash containing data to uniquely identify the user from the
    #        source system.
    #
    # Examples
    #
    #   handle('Andy')
    #   # => 1
    #
    #   handle('Evelyn')
    #   # => 2
    #
    # Returns the Integer id.
    def handle(data)
      id = Bluecap.redis.hget('user.map', data)
      return id.to_i if id

      id = Bluecap.redis.incr('user.ids')
      if Bluecap.redis.hsetnx('user.map', data, id)
        return id
      else
        # Race condition, another process has set the id for this user.
        # The unused id shouldn't cause inaccuracies in reporting since
        # the position will be 0 in all bitsets across the system.
        return redis.hget('user.map', data).to_i
      end
    end

  end
end
