module Bluecap
  module Keys
    def self.clean(str)
      str.strip.downcase.gsub(/[^a-z0-9]/, '.')
    end
  end
end
