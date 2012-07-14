require 'date'
require 'securerandom'

module Bluecap
  class Report

    attr_reader :initial_event, :engagement_event, :attributes, :year_month

    # Initialize a Report handler.
    #
    # data - A Hash containing options to scope the report by:
    #        :initial_event     - The String event that cohorts shared.
    #        :engagement_event  - The String event to track engagement by.
    #        :attributes        - The Hash attributes of users (optional).
    #        :start_date        - The String start date of the report.
    #        :end_date          - The String end date of the report.
    #
    # Examples
    #
    #   Bluecap::Report.new(
    #     initial_event: 'Created Account',
    #     engagement_event: 'Logged In',
    #     attributes: {
    #       country: 'Australia',
    #       gender: 'Female'
    #     },
    #     start_date: '20120401',
    #     end_date: '20120430'
    #   )
    def initialize(data)
      @initial_event = data.fetch(:initial_event)
      @engagement_event = data.fetch(:engagement_event)
      @attributes = data.fetch(:attributes, Hash.new)
      @start_date = Date.parse(data.fetch(:start_date))
      @end_date = Date.parse(data.fetch(:end_date))
    end

    def report_id
      Bluecap.redis.incr('report.ids')
    end

    # Generates a report to track engagement of cohorts over time.
    #
    # Returns the String with report data in JSON format.
    def handle
      report = Hash.new
      (@start_date...@end_date).each do |date|
        cohort = Cohort.new(
          :initial_event => @initial_event,
          :attributes => @attributes,
          :date => date,
          :report_id => report_id
        )

        # The start date of the engagement is measured from the day after the
        # initial event.
        engagement = Engagement.new(
          :cohort => cohort,
          :engagement_event => engagement_event,
          :start_date => date + 1,
          :end_date => @end_date,
          :report_id => report_id
        )

        cohort_results = Hash.new
        cohort_results[:total] = cohort.total
        cohort_results[:engagement] = engagement.measure
        report[date.strftime('%Y%m%d')] = cohort_results
      end

      MultiJson.dump(report)
    end

  end
end
