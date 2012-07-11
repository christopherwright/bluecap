require 'date'

module Bluecap
  class Event

    # Converts a UNIX timestamp to a %Y%m%d String.
    #
    # timestamp - The Integer timestamp to convert.
    #
    # Examples
    #
    #   date(1341845456)
    #   # => "20120710"
    #
    # Returns the String date.
    def date(timestamp)
      Time.at(timestamp).strftime('%Y%m%d')
    end

    # Returns a key used to store the events for a day.
    #
    # name      - The String event to track.
    # timestamp - The Integer timestamp the event occurred at.
    #
    # Examples
    #
    #    key('Sign Up', 1341845456)
    #    # => "events:sign.up:20120710"
    #
    # Returns the String key.
    def key(name, timestamp)
      "events:#{Bluecap::Keys.clean(name)}:#{date(timestamp)}"
    end

    # Store the user's event in a bitset of all the events matching that name
    # for the date.
    #
    # data - A Hash containing event data.
    #
    # Examples
    #
    #    handle({
    #      event: {
    #        id: 3,
    #        name: 'Created Account',
    #        timestamp: 1341845456
    #      }
    #    })
    #
    # Returns nil.
    def handle(data)
      data[:event][:timestamp] ||= Time.now.to_i
      Bluecap.redis.setbit(
        key(data[:event][:name], data[:event][:timestamp]),
        data[:event][:id],
        1)

      nil
    end
  end
end
