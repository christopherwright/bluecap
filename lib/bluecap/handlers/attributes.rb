module Bluecap
  class Attributes

    def key(attribute, value)
      "attributes:#{Bluecap::Keys.clean(attribute)}:#{Bluecap::Keys.clean(value)}"
    end

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
