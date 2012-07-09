require 'helper'

describe 'Server' do

  before do
    Bluecap.redis.flushall
    @server = Object.new
    @server.extend(Bluecap::Server)
    Bluecap::Server.handlers = {}
  end

  it 'should route to appropriate handler' do
    handler = double()
    handler.should_receive(:handle)
      .with(hash_including(identifier: 'andy'))
      .once
    Bluecap::Server.handlers = {identifier: handler}
    @server.receive_data('{"identifier": "andy"}')
  end

  it 'should not throw an exception when no handler is found' do
    @server.receive_data('{"nope": "nuh-uh"}')
  end

end
