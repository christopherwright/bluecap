module Bluecap
  module Server

    def self.handlers
      @handlers ||= Hash.new
    end

    def self.handlers=(handlers)
      @handlers = handlers
    end

    def post_init
      puts "Connection made to server"
    end

    def unbind
      puts "Connection closed with server"
    end

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
        return nil
      end
    rescue Exception => e
      warn "#{Time.now}: Uncaught error #{e.message}"
    end

    class Daemon

      def run
        EventMachine::run do
          EventMachine::start_server('0.0.0.0', 6088, Bluecap::Server)
        end
      end

    end

  end
end
