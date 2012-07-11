module Bluecap
  class Report
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
    #       from: '2012-03-17',
    #       to: '2012-06-17
    #     },
    #     attributes: {
    #       country: 'Australia',
    #       gender: 'Female'
    #     },
    #     buckets: 'weekly',
    #     across: 'weekly'
    #   })
    #
    # Returns the String with report data in JSON format.
    def handle(data)
    end
  end
end
