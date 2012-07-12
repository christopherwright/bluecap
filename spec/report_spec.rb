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
        from: '20120601',
        to: '20120604'
      },
      attributes: {
        country: 'Australia',
        gender: 'Male',
      },
      buckets: 'daily',
      across: 'daily'
    }

    json = @report.handle(data)
    body = MultiJson.load(json, symbolize_keys: true)
    dates = ['20120601', '20120602', '20120603', '20120604']
    body.keys.should include(*dates.map { |d| d.to_sym })
  end

end
