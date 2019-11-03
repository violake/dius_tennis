# frozen_string_literal: true

module Tennis
  class Game
    attr_reader :point_pair, :winning_point, :tie_break

    WINNING_POINT = 4
    TIE_BREAK_WINNING_POINT = 7

    def initialize(tie_break: false)
      @tie_break = tie_break
      @winning_point = tie_break ? TIE_BREAK_WINNING_POINT : WINNING_POINT
      @point_pair = PointPair.new
    end

    def points
      point_pair.points
    end

    def add_point(point_id)
      point_pair.add_one_point(point_id)
    end

    def complete?
      point_pair.reach(winning_point) && point_pair.diff > 1
    end

    def winner_id
      point_pair.large_point_id if complete?
    end
  end
end
