module Bluecap
  class Engagement

    def initialize(options)
      @cohort = options.fetch(:cohort)
      @engagement_event = options.fetch(:engagement_event)
      @start_date = options.fetch(:start_date)
      @end_date = options.fetch(:end_date)
      @report_id = options.fetch(:report_id)
    end

    def key(date)
      Bluecap::Keys.engagement(@report_id, @cohort.id, date.strftime('%Y%m%d'))
    end

    def keys(date)
      [@cohort.key, Bluecap::Keys.event(@engagement_event, date.strftime('%Y%m%d'))]
    end

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
