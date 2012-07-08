module Bluecap
  module Receiver

    def self.handlers
      @handlers ||= Hash.new
    end

    def self.handlers=(handlers)
      @handlers = handlers
    end

    def receive_data(data)
      begin
        body = MultiJson.load(data)
        key = body.first[0].to_sym if body.first
        if Bluecap::Receiver.handlers.key?(key)
          Bluecap::Receiver.handlers[key].handle(body)
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
          EventMachine::open_datagram_socket('0.0.0.0', 6088, Bluecap::Receiver)
        end
      end

    end

  end
end
