# frozen_string_literal: true

require 'tennis/game'
require 'tennis/point_pair'

module Tennis
  class Set
    attr_reader :point_pair, :current_game

    SET_WINNING_POINT = 6

    def initialize
      @point_pair = PointPair.new
      @games = []
      @current_game = nil
    end

    def points
      point_pair.points
    end

    def add_game_point(point_id)
      current_game || create_new_game
      current_game.add_point(point_id)

      if current_game.complete?
        point_pair.add_one_point(current_game.winner_id)
        @current_game = nil
      end
    end

    def complete?
      (point_pair.reach(SET_WINNING_POINT) && point_pair.diff > 1) ||
        point_pair.reach(SET_WINNING_POINT + 1)
    end

    def winner_id
      point_pair.large_point_id if complete?
    end

    private

    def tie_break?
      point_pair.points.all? { |point| point == SET_WINNING_POINT }
    end

    def create_new_game
      @current_game = tie_break? ? Game.new(Game::TIE_BREAK_WINNING_POINT) : Game.new 
      @games << current_game
    end
  end
end
