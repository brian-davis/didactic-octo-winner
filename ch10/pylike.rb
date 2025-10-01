# Python functions
module Pylike
  module Collections
    # This is a builder for a histogram Hash.
    #
    # >> require 'pycall'
    # >> coll = PyCall.import_module("collections")
    # >> h = coll.Counter.([1,2,3,2,1])
    # => Counter({1: 2, 2: 2, 3: 1})
    # >> h[1]
    # => 2
    # >> h[3]
    # => 1
    module Counter
      class << self
        # Easy enough to DIY in Ruby.
        def [](arr)
          arr.each.with_object({}) do |e, memo|
            memo[e] ||= 0
            memo[e] += 1
          end
        end
      end
    end
  end
end
