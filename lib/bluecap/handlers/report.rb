require 'date'
require 'securerandom'

module Bluecap
  class Report

    attr_reader :initial_event, :engagement_event, :report_start_date,
      :report_end_date, :attributes, :buckets, :frequency

    # Initialize a Report handler.
    #
    # data - A Hash containing options to scope the report by:
    #        :initial_event     - The String event that cohorts shared.
    #        :engagement_event  - The String event to track engagement by.
    #        :report_start_date - The String start date of the report.
    #        :report_start_date - The String end date of the report.
    #        :attributes       - The Hash attributes of users (optional).
    #        :buckets          - The String period to group users by (e.g.:
    #                            monthly).
    #        :frequency        - The String frequency to check engagement by
    #                            (e.g.: weekly).
    #
    # Examples
    #
    #   Bluecap::Report.new(
    #     initial_event: 'Created Account',
    #     engagement_event: 'Logged In',
    #     report_start_date: '20120401',
    #     report_end_date: '20120414',
    #     attributes: {
    #       country: 'Australia',
    #       gender: 'Female'
    #     },
    #     buckets: 'weekly',
    #     frequency: 'daily'
    #   )
    def initialize(data)
      @initial_event = data.fetch(:initial_event)
      @engagement_event = data.fetch(:engagement_event)
      @report_start_date = Date.parse(data.fetch(:report_start_date))
      @report_end_date = Date.parse(data.fetch(:report_end_date))
      @attributes = data.fetch(:attributes, Hash.new)
      @buckets = data.fetch(:buckets)
      @frequency = data.fetch(:frequency)
    end

    def report_id
      Bluecap.redis.incr('report.ids')
    end

    # Generates a report to track engagement of cohorts over time.
    #
    # Returns the String with report data in JSON format.
    def handle
      report = Hash.new

      MultiJson.dump(report)
    end

  end
end
