module Bluecap
  module Server

    # Returns a Hash of handlers, creating a new empty hash if none have
    # previously been set.
    def self.handlers
      @handlers ||= Hash.new
    end

    # Assign handlers to respond to new data.
    #
    # handlers - A Hash of handlers. When the server receives data, it checks
    #            the root level key of the data - if the handlers Hash has
    #            a matching key, the handler object in the value is used to
    #            respond to the request.
    #
    # Examples
    #
    #   handlers = {
    #     event: Bluecap::Event.new,
    #     identify: Bluecap::Identify.new
    #   }
    #
    # Returns nothing.
    def self.handlers=(handlers)
      @handlers = handlers
    end

    def post_init
      puts "Connection made to server"
    end

    def unbind
      puts "Connection closed with server"
    end

    # Parses JSON data received from a client, using the root namespace key
    # to route the request to a handler. This is called directly by
    # EventMachine.
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
        body = MultiJson.load(data, symbolize_keys: true)
        key = body.first[0].to_sym if body.first
        if Bluecap::Server.handlers.key?(key)
          response = Bluecap::Server.handlers[key].handle(body)
          send_data(response) if response
        end
      rescue MultiJson::DecodeError => e
        warn e
      end
    rescue Exception => e
      warn "#{Time.now}: Uncaught error #{e.message}"
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
