module Bluecap
  module Server

    # Returns a Hash of handlers, creating a new empty hash if none have
    # previously been set.
    def self.handlers
      @handlers ||= Hash.new
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
      klass = Bluecap::Server.handlers.fetch(message.recipient, Bluecap::NullObject)
      handler = klass.new(message.contents)
      handler.handle
      handler.response
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
      message = Bluecap::Message.new(data)
      response = process(message)
      send_data(response) if response
    end

    class Daemon

      # Starts a TCP server running on the EventMachine loop.
      #
      # Returns nothing.
      def run
        EventMachine::run do
          EventMachine::start_server('0.0.0.0', 6088, Bluecap::Server)
        end
      end

    end

  end
end
