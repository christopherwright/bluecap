module Bluecap
  class Report
    def handle(data)
      """
      data = {
        events: {
          from: 'Created Account',
          to: 'Logged In'
        },
        dates: {
          from: '2012-03-17',
          to: '2012-06-17'
        },
        attributes: {
          country: 'Australia',
          gender: 'Male',
        },
        buckets: 'weekly',
        across: 'weekly'
      }
      """

      1
    end
  end
end
