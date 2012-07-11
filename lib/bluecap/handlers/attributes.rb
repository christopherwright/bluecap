module Bluecap
  class Attributes

    # Returns a key used to store all the users who have the same value for
    # an attribute.
    #
    # attribute - The String property being tracked.
    # value     - The String value of the property.
    #
    # Examples
    #
    #   key('gender', 'female')
    #   # => "attributes:gender:female"
    #
    #   key('Country', 'Australia')
    #   # => "attributes:country:australia"
    #
    # Returns the String key.
    def key(attribute, value)
      "attributes:#{Bluecap::Keys.clean(attribute)}:#{Bluecap::Keys.clean(value)}"
    end

    # Store attributes for a user. Each attribute/value has its own bitset
    # so this is best used with data that has a limited number of values
    # (e.g.: gender, country).
    #
    # data - A Hash containing attributes to set for a user.
    #
    # Examples
    #
    #   handle({
    #     attributes: {
    #       hash: {
    #         gender: 'Female',
    #         country: 'Australia'
    #       },
    #       id: 3
    #     }
    #   })
    #
    # Returns nil.
    def handle(data)
      Bluecap.redis.multi do
        data[:attributes][:hash].each do |k, v|
          Bluecap.redis.setbit(
            key(k.to_s, v),
            data[:attributes][:id],
            1
          )
        end
      end

      nil
    end

  end
end
