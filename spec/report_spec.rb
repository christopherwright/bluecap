require 'helper'

describe Bluecap::Report do

  before do
    Bluecap.redis.flushall
  end

  subject do
    Bluecap::Report.new(
      initial_event: 'Created Account',
      engagement_event: 'Logged In',
      report_start_date: '20120401',
      report_end_date: '20120414', 
      attributes: {
        country: 'Australia',
        gender: 'Female'
      },
      buckets: 'weekly',
      frequency: 'daily'
    )

  end

  it 'should generate report' do
    json = subject.handle
    body = MultiJson.load(json, symbolize_keys: true)
  end

end
