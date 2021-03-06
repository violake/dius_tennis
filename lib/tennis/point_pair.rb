# frozen_string_literal: true

module Tennis
  class PointPair
    def initialize
      @points = [0, 0]
    end

    def points
      @points.dup
    end

    def add_one_point(id)
      @points[id] += 1
    end

    def reach(value)
      @points.max >= value
    end

    def large_point_id
      @points.index(points.max)
    end

    def diff
      (@points[0] - @points[1]).abs
    end

    def to_s
      @points.join('-')
    end
  end
end
