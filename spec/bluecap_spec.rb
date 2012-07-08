require 'helper'

describe 'Bluecap' do

  before do
    Bluecap.redis.flushall
    @receiver = Object.new
    @receiver.extend(Bluecap::Receiver)
    Bluecap::Receiver.handlers = {}
  end

  it 'should route to appropriate handler' do
    handler = double()
    handler.should_receive(:handle)
      .with(hash_including('identifier' => 'bob'))
      .once
    Bluecap::Receiver.handlers = {identifier: handler}
    @receiver.receive_data('{"identifier": "bob"}')
  end

  it 'should not throw an exception when no handler is found' do
    @receiver.receive_data('{"nope": "nuh-uh"}')
  end
end
