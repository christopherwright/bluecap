require 'socket'

module Bluecap
  module Server

    # Returns a Hash of handlers, creating a new empty hash if none have
    # previously been set.
    def self.handlers
      @handlers ||= {
        attributes: Bluecap::Attributes,
        event: Bluecap::Event,
        identify: Bluecap::Identify,
        report: Bluecap::Report
      }
    end

    # Assign handlers to respond to new data.
    #
    # handlers - A Hash of lookup keys to handler classes.
    #
    # Examples
    #
    #   handlers = {
    #     event: Bluecap::Event,
    #     identify: Bluecap::Identify
    #   }
    #
    # Returns nothing.
    def self.handlers=(handlers)
      @handlers = handlers
    end

    def process(message)
      klass = Bluecap::Server.handlers.fetch(message.recipient, Bluecap::NullHandler)
      port, ip_address = Socket.unpack_sockaddr_in(get_peername)
      Bluecap.log "Message received for #{message.recipient} handler from #{ip_address}:#{port}"
      handler = klass.new(message.contents)
      handler.handle
    end

    # Process a message received from a client, sending a response if
    # necessary.
    #
    # data - The String containing JSON received from the client.
    #
    # Examples
    #
    #    receive_data('{"identify": "Andy"}')
    #
    # Returns nothing.
    def receive_data(data)
      begin
        message = Bluecap::Message.new(data)
        response = process(message)
        send_data(response) if response
      rescue Exception => e
        Bluecap.log e
      end
    end

    # Starts a TCP server running on the EventMachine loop.
    #
    # Returns nothing.
    def self.run
      EventMachine::run do
        EventMachine::start_server(Bluecap.host, Bluecap.port, Bluecap::Server)
        Bluecap.log "Server started on #{Bluecap.host}:#{Bluecap.port}"
      end
    end

  end
end
