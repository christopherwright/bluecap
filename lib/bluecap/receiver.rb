module Bluecap
  module Receiver

    def receive_data(data)
      begin
        body = MultiJson.load(data)
      rescue MultiJson::DecodeError => e
        warn e
        return nil
      end

      puts body.keys.first
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
