module Bluecap
  class Report
    # Generates a cohort report for the client. Finds the time between when
    # a person has tracked two events (e.g.: created an account then logged
    # back in).
    #
    # data - A Hash containing report options.
    #        :events     -
    #        :dates      -
    #        :attributes -
    #        :buckets    -
    #        :across     -
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
