require 'helper'

describe 'Event handler' do

  before do
    Bluecap.redis.flushall
    @event = Bluecap::Event.new
  end

  it 'should convert unix timestamps to strings in %Y%m%d format' do
    @event.date(1341845456).should eq('20120710')
  end

  it 'should create event key using cleaned name and date' do
    @event.key('Sign Up', 1341845456).should eq('events:sign.up:20120710')
  end

  it 'should track event for user by setting corresponding bit to 1' do
    data = {
      id: 3,
      name: 'Created Account',
      timestamp: Time.now.to_i
    }

    key = @event.key(data[:name], data[:timestamp])
    Bluecap.redis.getbit(key, data[:id]).should eq (0)
    @event.handle(data)
    Bluecap.redis.getbit(key, data[:id]).should eq (1)
  end

end
