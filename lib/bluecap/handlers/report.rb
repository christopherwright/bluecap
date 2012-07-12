require 'date'
require 'securerandom'

module Bluecap
  class Report

    def keys_for_attributes
      @keys_for_attributes ||= @attributes.map{ |k, v| Bluecap::Attributes.key(k.to_s, v) }
    end

    # Generates a cohort report for the client. Finds the time between when
    # a person has tracked two events (e.g.: created an account then logged
    # back in).
    #
    # data - A Hash containing options to scope the report by.
    #        :events     - The Hash events to report from and to.
    #        :dates      - The Hash dates to report from and to.
    #        :attributes - The Hash attributes of users (optional).
    #        :buckets    - The String to group users by (e.g.: monthly).
    #        :across     - The String frequency to check event tracking
    #                      (e.g.: weekly).
    #
    # Examples
    #
    #   handle({
    #     events: {
    #       from: 'Created Account',
    #       to: 'Logged In'
    #     },
    #     dates: {
    #       from: '20120401',
    #       to: '20120414'
    #     },
    #     attributes: {
    #       country: 'Australia',
    #       gender: 'Female'
    #     },
    #     buckets: 'daily',
    #     across: 'daily'
    #   })
    #
    # Returns the String with report data in JSON format.
    def handle(data)
      report = Hash.new
      report_id = SecureRandom.hex(8)
      @attributes = data[:attributes]
      keys = keys_for_attributes
      date_from = Date.parse(data[:dates][:from])
      date_to = Date.parse(data[:dates][:to])
      (date_from..date_to).each do |date|
        date_str = date.strftime('%Y%m%d')
        stats = Hash.new
        total_key = "reports:#{report_id}:#{date_str}:total"
        keys_for_first_event = Array.new
        keys_for_first_event << Bluecap::Event.key(data[:events][:from], date_str)
        keys_for_first_event.concat(keys_for_attributes)
        Bluecap.redis.bitop('and', total_key, keys_for_first_event)
        Bluecap.redis.expire(total_key, 3600)
        stats[:total] = Bluecap.redis.get(total_key) || 0
        report[date.strftime('%Y%m%d')] = stats
      end

      # {
      #   '20120301' => {
      #     total: 5591,
      #     retention: [53, 31, 29, 15],
      #   },
      #   '20120318' => {
      #     total: 7813,
      #     retention: [55, 25, 20]
      #   }
      # }

      MultiJson.dump(report)
    end

  end
end
