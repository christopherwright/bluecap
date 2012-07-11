require 'date'

module Bluecap
  class Event
    def date(timestamp)
      Time.at(timestamp).strftime('%Y%m%d')
    end

    def key(name, timestamp)
      return "events:#{Bluecap::Keys.clean(name)}:#{date(timestamp)}"
    end

    def handle(data)
      data[:event][:timestamp] ||= Time.now.to_i
      Bluecap.redis.setbit(
        key(data[:event][:name], data[:event][:timestamp]),
        data[:event][:id],
        1)
    end
  end
end
