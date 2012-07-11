require 'helper'

describe 'Report handler' do

  before do
    Bluecap.redis.flushall
    @report = Bluecap::Report.new
  end

  it 'should generate report' do
    # TODO: Split this into several tests once design takes shape.
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

    results = @report.handle(data)
    results.should eql(1)
  end

end
