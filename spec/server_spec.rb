require 'helper'

describe Bluecap::Server do

  subject do
    server = Object.new
    server.extend(Bluecap::Server)
  end

  it 'should route to appropriate handler' do
    handler = double()
    handler.should_receive(:handle)
      .with('andy')
      .once
    Bluecap::Server.handlers = {identify: handler}
    subject.receive_data('{"identify": "andy"}')
  end

end
