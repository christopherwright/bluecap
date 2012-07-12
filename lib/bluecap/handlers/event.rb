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
    def self.date(timestamp)
      Time.at(timestamp).strftime('%Y%m%d')
    end

    # Returns a key used to store the events for a day.
    #
    # name - The String event to track.
    # date - The String date in %Y%m%d format.
    #
    # Examples
    #
    #    key('Sign Up', '20120710')
    #    # => "events:sign.up:20120710"
    #
    # Returns the String key.
    def self.key(name, date)
      "events:#{Bluecap::Keys.clean(name)}:#{date}"
    end

    # Store the user's event in a bitset of all the events matching that name
    # for the date.
    #
    # data - A Hash containing event data.
    #
    # Examples
    #
    #    handle({
    #      id: 3,
    #      name: 'Created Account',
    #      timestamp: 1341845456
    #    })
    #
    # Returns nil.
    def handle(data)
      data[:timestamp] ||= Time.now.to_i
      Bluecap.redis.setbit(
        self.class.key(data[:name], self.class.date(data[:timestamp])),
        data[:id],
        1)

      nil
    end
  end
end
