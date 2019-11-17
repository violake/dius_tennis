# frozen_string_literal: true

require 'tennis/point_pair'

module Tennis
  class Game
    attr_reader :point_pair, :winning_point

    ORDINARY_WINNING_POINT = 4
    TIE_BREAK_WINNING_POINT = 7
    GAME_POINT_NAMES = %w[0 15 30 40].freeze
    DEUCE = 'Deuce'
    ADVANTAGE = 'Advantage'

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

    def score(players)
      tie_break? ? point_pair.to_s : ordinary_game_score(players)
    end

    private

    def tie_break?
      winning_point != ORDINARY_WINNING_POINT
    end

    def tie_break_score
      point_pair.to_s
    end

    def ordinary_game_score(players)
      if deuce_score?
        DEUCE
      elsif advantage_score?
        "#{ADVANTAGE} #{players[point_pair.large_point_id]}"
      else
        score_by_name
      end
    end

    def deuce_score?
      point_pair.reach(3) && point_pair.diff.zero?
    end

    def advantage_score?
      point_pair.reach(4) && point_pair.diff == 1
    end

    def score_by_name
      point_pair.points.map { |point| GAME_POINT_NAMES[point] }.join('-')
    end
  end
end
