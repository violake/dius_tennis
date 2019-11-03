# frozen_string_literal: true

require 'tennis/game'
require 'tennis/set'

class Match
  attr_reader :players, :set, :current_game

  GAME_POINT_NAMES = %w[0 15 30 40].freeze
  DEUCE = 'Deuce'
  ADVANTAGE = 'Advantage'
  MATCH_OVER_ERROR = 'Match is over!'

  def initialize(player1_name, player2_name)
    @players = [player1_name, player2_name]
    @set = Tennis::Set.new
  end

  def point_won_by(player_name)
    raise StandardError, 'Match is over!' if set.complete?

    set.add_game_point(players.index(player_name))
  end

  def score
    complete? ? winning_score : set_and_game_score
  end

  private

  def winning_score
    set.points.join('-') + ", #{players[set.winner_id]} win" if complete?
  end

  def complete?
    set.complete?
  end

  def set_and_game_score
    set.points.join('-') + if set.current_game
                             ', ' + current_game_score(set.current_game)
                           else
                             ''
                           end
  end

  def current_game_score(game)
    game.tie_break ? game.points.join('-') : game_score(game.points)
  end

  def game_score(game)
    if game.uniq.count == 1 && game[0] >= 3
      DEUCE
    elsif game.max > 3 && (game[0] - game[1]).abs == 1
      "#{ADVANTAGE} #{players[game.index(game.max)]}"
    else
      game.map { |point| GAME_POINT_NAMES[point] }.join('-')
    end
  end
end
