require 'date'

module Bluecap
  class Event

    attr_reader :id, :name, :timestamp

    # Initialize an Event handler.
    #
    # data - A Hash containing event data:
    #        :id        - The Integer identifer of the user that generated
    #                     the event.
    #        :name      - The String type of event.
    #        :timestamp - The Integer UNIX timestamp when the event was created,
    #                     defaults to current time (optional).
    #
    # Examples
    #
    #    Bluecap::Event.new(
    #      id: 3,
    #      name: 'Created Account',
    #      timestamp: 1341845456
    #    )
    def initialize(data)
      @id = data.fetch(:id)
      @name = data.fetch(:name)
      @timestamp = data.fetch(:timestamp, Time.now.to_i)
    end

    # Converts the object's timestamp to a %Y%m%d String.
    #
    # Returns the String date.
    def date
      Time.at(@timestamp).utc.strftime('%Y%m%d')
    end

    # Proxy for an event key.
    #
    # Returns the String key.
    def key
      Bluecap::Keys.event(@name, date)
    end

    # Store the user's event in a bitset of all the events matching that name
    # for the date.
    #
    # Returns nil.
    def handle
      Bluecap.redis.setbit(key, @id, 1)

      nil
    end
  end
end
