module Bluecap
  class Message

    def initialize(data)
      @data = MultiJson.load(data, symbolize_keys: true)
    end

    def recipient
      @data.first[0].to_sym if @data.first
    end

    def contents
      @data.first[1]
    end

  end
end
