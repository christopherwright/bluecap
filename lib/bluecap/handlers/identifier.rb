module Bluecap
  class Identifier

    def handle(data)
      name = data[:identifier]
      id = Bluecap.redis.hget('user.map', name)
      if id.nil?
        id = Bluecap.redis.incr('user.ids')
        if Bluecap.redis.hsetnx('user.map', name, id)
          return id
        else
          # Race condition, another process has set the id for this user.
          # The unused id shouldn't cause inaccuracies in reporting since
          # it will be 0 in all bitfields across the system.
          return redis.hget('user.map', name)
        end
      end
    end

  end
end
