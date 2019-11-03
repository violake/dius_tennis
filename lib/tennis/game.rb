# frozen_string_literal: true

module Tennis
  class Game
    attr_reader :points, :winning_point

    WINNING_POINT = 4
    TIE_BREAK_WINNING_POINT = 7

    def initialize(tie_break: false)
      @winning_point = tie_break ? TIE_BREAK_WINNING_POINT : WINNING_POINT
      @points = [0, 0]
    end

    def add_point(point_id)
      points[point_id] += 1
    end

    def complete?
      points && points.max >= winning_point && (points[0] - points[1]).abs > 1
    end

    def winner_id
      points.index(points.max) if complete?
    end
  end
end
