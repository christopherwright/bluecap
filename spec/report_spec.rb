require 'helper'

describe Bluecap::Report do

  before do
    Bluecap.redis.flushall
  end

  subject do
    Bluecap::Report.new(
      initial_event: 'Created Account',
      engagement_event: 'Logged In',
      attributes: {
        country: 'Australia',
        gender: 'Female'
      },
      year_month: '201207'
    )

  end

  it 'should generate report' do
    json = subject.handle
    body = MultiJson.load(json, symbolize_keys: true)
  end

end
