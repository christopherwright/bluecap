module Bluecap
  class Message

    # Initialize a Message with data.
    #
    # data - The String JSON message to parse.
    def initialize(data)
      @data = MultiJson.load(data, symbolize_keys: true)
    end

    # The signature of the handler that should respond to the message.
    #
    # Examples
    #
    #    message = Message.new('{"identify": "Evelyn"}')
    #    message.recipient
    #    # => :identify
    #
    # Returns the Symbol recipient of the messsage.
    def recipient
      @data.first[0].to_sym if @data.first
    end

    # The contents of the message.
    #
    # Examples
    #
    #    message = Message.new('{"identify": "Evelyn"}')
    #    message.contents
    #    # => "Evelyn"
    #
    # Returns the contents of the message; the data type is different based on
    # the contents of the message.
    def contents
      @data.first[1]
    end

  end
end
