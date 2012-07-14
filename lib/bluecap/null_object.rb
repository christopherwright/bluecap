module Bluecap
  class NullObject

    def method_missing(*ags, &block)
      self
    end

  end
end
