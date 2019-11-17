# frozen_string_literal: true

require 'tennis/point_pair'

module Tennis
  class Game
    attr_reader :point_pair, :winning_point

    ORDINARY_WINNING_POINT = 4
    TIE_BREAK_WINNING_POINT = 7

    def initialize(winning_point = ORDINARY_WINNING_POINT)
      @winning_point = winning_point
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

    def tie_break?
      winning_point != ORDINARY_WINNING_POINT
    end
  end
end
