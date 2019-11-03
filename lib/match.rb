# frozen_string_literal: true

require 'tennis/game'
require 'tennis/set'

class Match
  attr_reader :players, :set, :current_game

  GAME_POINT_NAMES = %w[0 15 30 40].freeze

  def initialize(player1_name, player2_name)
    @players = [player1_name, player2_name]
    @set = Tennis::Set.new
  end

  def point_won_by(player_name)
    raise StandardError, 'Match is over!' if set.complete?

    set.add_game_point(players.index(player_name))
  end

  def score
    if set.complete?
      set.points.join('-') + ", #{players[set.winner_id]} win"
    elsif set.current_game
      set.points.join('-') + ', ' + current_game_score(set.current_game.points)
    else
      set.points.join('-')
    end
  end

  private

  def current_game_score(game)
    set.tie_break? ? game.join('-') : game_score(game)
  end

  def game_score(game)
    if game.uniq.count == 1 && game[0] >= 3
      'Deuce'
    elsif game.max > 3 && (game[0] - game[1]).abs == 1
      "Advantage #{players[game.index(game.max)]}"
    else
      game.map { |point| GAME_POINT_NAMES[point] }.join('-')
    end
  end
end
