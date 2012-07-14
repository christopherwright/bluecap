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
    #        :year_month        - The String year and month to report on.
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
    #     year_month: '201204'
    #   )
    def initialize(data)
      @initial_event = data.fetch(:initial_event)
      @engagement_event = data.fetch(:engagement_event)
      @attributes = data.fetch(:attributes, Hash.new)
      @year_month = data.fetch(:year_month)
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
