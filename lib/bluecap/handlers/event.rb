require 'date'

module Bluecap
  class Event
    def clean_name(name)
      name.strip.downcase.gsub(/[^a-z0-9]/, '.')
    end

    def date(timestamp)
      Time.at(timestamp).strftime('%Y%m%d')
    end

    def key(name, timestamp=Time.now.to_i)
      return "events:#{clean_name(name)}:#{date(timestamp)}"
    end

    def handle(data)
      Bluecap::Redis.setbit(
        key(data[:event][:name], data[:event][:timestamp]),
        data[:event][:id],
        1)
    end
  end
end
