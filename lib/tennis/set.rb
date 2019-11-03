# frozen_string_literal: true

require 'tennis/game'

module Tennis
  class Set
    attr_reader :points, :current_game

    SET_WINNING_POINT = 6

    def initialize
      @points = [0, 0]
      @games = []
      @current_game = nil
    end

    def add_game_point(point_id)
      current_game || create_new_game
      current_game.add_point(point_id)

      if current_game.complete?
        points[current_game.winner_id] += 1
        @current_game = nil
      end
    end

    def complete?
      (points.max >= SET_WINNING_POINT && (points[0] - points[1]).abs > 1) ||
        points.max == SET_WINNING_POINT + 1
    end

    def winner_id
      points.index(points.max) if complete?
    end

    private

    def tie_break?
      points.uniq.count == 1 && points[0] == SET_WINNING_POINT
    end

    def create_new_game
      @current_game = Game.new(tie_break: tie_break?)
      @games << current_game
    end
  end
end
