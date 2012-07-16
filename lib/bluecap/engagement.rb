module Bluecap
  class Engagement

    # Initialize an Engagement class to measure Cohort retention.
    #
    # options - A hash containing options that define the engagement.
    #           :cohort           - The Cohort to measure engagement for.
    #           :engagement_event - The String event that defines engagement.
    #           :start_date       - The Date starting period to measure
    #                               engagement for.
    #           :end_date         - The Date ending period to measure
    #                               engagement for.
    #           :report_id        - The Integer identifier of the report this
    #                               cohort is being used with.
    #
    # Examples
    #
    #   engagement = Bluecap::Engagement.new :cohort => cohort,
    #     :engagement_event => 'Logged In',
    #     :start_date => Date.parse('20120702'),
    #     :end_date => Date.parse('20120707'),
    #     :report_id => 1
    def initialize(options)
      @cohort = options.fetch(:cohort)
      @engagement_event = options.fetch(:engagement_event)
      @start_date = options.fetch(:start_date)
      @end_date = options.fetch(:end_date)
      @report_id = options.fetch(:report_id)
    end

    # A key name in Redis where the bitcount operation for engagement on a
    # date should be stored.
    #
    # Returns the String key name.
    def key(date)
      Bluecap::Keys.engagement(@report_id, @cohort.id, date.strftime('%Y%m%d'))
    end

    # The keys that comprise the bitmask for the engagement on a date.
    #
    # Returns the Array of String keys.
    def keys(date)
      [@cohort.key, Bluecap::Keys.event(@engagement_event, date.strftime('%Y%m%d'))]
    end

    # Measure the engagement of a cohort over a given period.
    #
    # Examples
    #
    #    measure
    #    # => {"20120702" =>  100.0, "20120703" => 50.0, ...}
    #
    # Returns a Hash with engagement percentages for each day in the period.
    def measure
      results = Hash.new
      (@start_date..@end_date).each do |date|
        key_name = key(date)
        Bluecap.redis.multi do
          Bluecap.redis.bitop('and', key_name, keys(date))
          Bluecap.redis.expire(key_name, 3600)
        end
        sum_for_day = Bluecap.redis.bitcount(key_name) || 0

        if not @cohort.total.zero?
          engagement_for_day = (sum_for_day.to_f / @cohort.total)
        else
          engagement_for_day = 0.to_f
        end
        engagement_for_day *= 100.0
        engagement_for_day.round(2)

        results[date.strftime('%Y%m%d')] = engagement_for_day
      end

      results
    end

  end
end
