module Bluecap
  class Cohort

    attr_reader :initial_event, :attributes, :date, :report_id

    # Initialize a Cohort.
    #
    # data - A Hash containing options to define the cohort:
    #        :initial_event     - The String event that members of the cohort
    #                             shared.
    #        :attributes        - The Hash attributes of cohort members.
    #        :date              - The Date the initial event occurred on.
    #        :report_id         - The Integer identifier of the report this
    #                             cohort is being used with.
    #
    # Examples
    #
    #   Bluecap::Cohort.new :initial_event => 'Created Account',
    #     :attributes => {:country => 'Australia', :gender => 'Female'},
    #     :date => Date.parse('20120701'),
    #     :report_id => 1
    def initialize(options)
      @initial_event = options.fetch(:initial_event)
      @attributes = options.fetch(:attributes, Hash.new)
      @date = options.fetch(:date)
      @report_id = options.fetch(:report_id)
    end

    # Convert the date of the cohort to a string.
    #
    # Returns the String date.
    def date_str
      @date.strftime("%Y%m%d")
    end

    # An identifier for the cohort. The date of the initial event is currently
    # unique for each cohort in a report, but that might change in the future if
    # cohorts are not limited to the initial event occurring on a single day.
    #
    # Returns the String id.
    def id
      date_str
    end

    # A Redis key containing a bitmask of all the properties for this cohort.
    # The method is memoized since the bitmask is cached in Redis for an hour.
    #
    # Returns the String key name in Redis.
    def key
      return @key if @key

      key_name = Bluecap::Keys.cohort(@report_id, id)
      Bluecap.redis.multi do
        Bluecap.redis.bitop('and', key_name, keys)
        Bluecap.redis.expire(key_name, 3600)
      end
      @key = key_name
    end

    # Generate an array of Redis keys where the attributes of users in the
    # cohort can be found.
    #
    # Returns the Array of String keys.
    def keys_for_attributes
      attributes = Bluecap::Attributes.new :id => 0, :attributes => @attributes
      attributes.keys
    end

    # Generate an array of Redis keys for use in creating a bitmask of the
    # cohort. This consists of the bitset of the users with the initial event
    # along with all the attributes of the cohort.
    #
    # Returns the Array of String keys.
    def keys
      keys_for_initial_event = Array.new
      keys_for_initial_event.push(Bluecap::Keys.event(@initial_event, date_str))
      keys_for_initial_event += keys_for_attributes
    end

    # Calculate the total number of users in this cohort by doing a bitcount
    # on the cohort bitmask. The method is memoized as the calculation is
    # expensive.
    #
    # Returns the Integer total.
    def total
      return @total if @total

      @total = Bluecap.redis.bitcount(key) || 0
    end

  end
end
