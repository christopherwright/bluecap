module Bluecap
  class NullHandler

    attr_reader :data

    # Initialize a NullHandler.
    def initialize(data)
      @data = data
    end

    # Catch the handle message.
    #
    # Returns nothing.
    def handle
      Bluecap.log "NullHandler received message, contents: #{@data}"
    end

  end
end
