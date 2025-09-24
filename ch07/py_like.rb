# Ruby implementations for Python standard helper functions.
class PyLike
  class << self
    # Like Python's `random.triangular(min, max, mode)`
    # Adapted from "simple-random" gem:
    # https://github.com/ealdent/simple-random/blob/master/lib/simple-random/simple_random.rb#L54
    def random_triangular(lower, upper, mode = nil)
      raise ArgumentError, 'Upper bound must be greater than lower bound.' unless lower < upper
      lower = lower.to_f
      upper = upper.to_f
      return rand(lower..upper) unless mode
      mode = mode.to_f

      raise ArgumentError, 'Mode must lie between the upper and lower limits' if mode > upper || mode < lower

      r = upper - lower
      u = rand() # (0.0..1.0)

      if u < ((mode - lower) / r)
        lower + Math.sqrt(u * r * (mode - lower))
      else
        upper - Math.sqrt((1.0 - u) * r * (upper - mode))
      end
    end

    # Like Python's `statistics.mean()`
    def mean(arr)
      arr.sum(0.0) / arr.length
    end
  end
end