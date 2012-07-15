module Bluecap
  class Cohort

    attr_reader :initial_event, :attributes, :date, :report_id

    def initialize(options)
      @initial_event = options.fetch(:initial_event)
      @attributes = options.fetch(:attributes, Hash.new)
      @date = options.fetch(:date)
      @report_id = options.fetch(:report_id)
    end

    def date_str
      @date.strftime("%Y%m%d")
    end

    def id
      date_str
    end

    def key
      return @key if @key

      key_name = Bluecap::Keys.cohort(@report_id, id)
      Bluecap.redis.multi do
        Bluecap.redis.bitop('and', key_name, keys)
        Bluecap.redis.expire(key_name, 3600)
      end
      @key = key_name
    end

    def keys_for_attributes
      attributes = Bluecap::Attributes.new :id => 0, :attributes => @attributes
      attributes.keys
    end

    def keys
      keys_for_initial_event = Array.new
      keys_for_initial_event.push(Bluecap::Keys.event(@initial_event, date_str))
      keys_for_initial_event += keys_for_attributes
    end

    def total
      return @total if @total

      @total = Bluecap.redis.bitcount(key) || 0
    end

  end
end
