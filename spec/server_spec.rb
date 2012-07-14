require 'helper'

describe 'Server' do

  before do
    @server = Object.new
    @server.extend(Bluecap::Server)
    Bluecap::Server.handlers = {}
  end

  it 'should route to appropriate handler' do
    handler = double()
    handler.should_receive(:handle)
      .with('andy')
      .once
    Bluecap::Server.handlers = {identify: handler}
    @server.receive_data('{"identify": "andy"}')
  end

end
