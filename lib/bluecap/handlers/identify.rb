module Bluecap
  class Identify

    def handle(data)
      name = data[:identify]
      id = Bluecap.redis.hget('user.map', name)
      return id.to_i if id

      id = Bluecap.redis.incr('user.ids')
      if Bluecap.redis.hsetnx('user.map', name, id)
        return id
      else
        # Race condition, another process has set the id for this user.
        # The unused id shouldn't cause inaccuracies in reporting since
        # the position will be 0 in all bitsets across the system.
        return redis.hget('user.map', name).to_i
      end
    end

  end
end
