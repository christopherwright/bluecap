module Bluecap
  class Attributes

    attr_reader :id, :attributes

    # Initialize an Attributes handler.
    #
    # data - A Hash containing attributes to set for a user:
    #        :attributes - The hash key/value pairs to be set.
    #        :id - The id of the user to set the attributes for.
    #
    # Examples
    #
    #   Bluecap::Attributes.new(
    #     id: 3,
    #     attributes: {
    #       gender: 'Female',
    #       country: 'Australia'
    #     }
    #   )
    def initialize(data)
      @id = data.fetch(:id)
      @attributes = data.fetch(:attributes)
    end

    # Returns keys for each of the attributes.
    #
    # Examples
    #
    #   attributes = Bluecap::Attributes.new(
    #     id:3,
    #     attributes: {
    #       gender: 'Female',
    #       country: 'Australia'
    #     }
    #   attributes.keys
    #   # => ["attributes:gender:female", "attributes:country:australia"]
    #
    # Returns the Array of keys.
    def keys
      @attributes.map { |k, v| key(k.to_s, v) }
    end

    # Returns a cleaned key for an attribute and value.
    #
    # Examples
    #
    #   key('gender', 'female')
    #   # => "attributes:gender:female"
    def key(attribute, value)
      "attributes:#{Bluecap::Keys.clean(attribute)}:#{Bluecap::Keys.clean(value)}"
    end

    # Store attributes for a user. Each attribute/value has its own bitset
    # so this is best used with data that has a limited number of values
    # (e.g.: gender, country).
    #
    # Returns nil.
    def handle
      Bluecap.redis.multi do
        keys.each { |k| Bluecap.redis.setbit(k, @id, 1) }
      end

      nil
    end

  end
end
