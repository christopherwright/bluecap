module Bluecap
  module Keys

    # Returns a cleaned version of a string for use in a Redis key. Strips,
    # downcases, then treats any remaining characters like word separators
    # as periods.
    #
    # str - The String to be cleaned.
    #
    # Examples
    #
    #   clean('Country')
    #   # => "country"
    #
    #   clean('Logged In')
    #   # => "logged.in"
    #
    # Returns the new String.
    def self.clean(str)
      str.strip.downcase.gsub(/[^a-z0-9]/, '.')
    end

    # Returns a key used to store the events for a day.
    #
    # Examples
    #
    #    Bluecap::Keys.event 'Sign Up', '20120710'
    #    # => "events:sign.up:20120710"
    #
    # Returns the String key.
    def self.event(name, date)
      "events:#{clean(name)}:#{date}"
    end

    def self.cohort(id, date)
    end

  end
end
