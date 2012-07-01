require 'helper'

describe 'Bluecap' do

  before do
    Bluecap.redis.flushall
    @receiver = Object.new
    @receiver.extend(Bluecap::Receiver)
  end

  it 'can create an identifier for a user' do
    @receiver.receive_data('{"hello": "goodbye"}')
    0.should eq(0)
  end
end
