# frozen_string_literal: true

require 'tennis/game'
require 'tennis/set'
require 'tennis/point_pair'

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
    "#{set.point_pair}, #{players[set.winner_id]} win" if complete?
  end

  def complete?
    set.complete?
  end

  def set_and_game_score
    set.point_pair.to_s + if set.current_game
                            ", #{current_game_score(set.current_game)}"
                          else
                            ''
                          end
  end

  def current_game_score(game)
    game.tie_break ? game.point_pair : ordinary_game_score(game.point_pair)
  end

  def ordinary_game_score(game_point_pair)
    if game_point_pair.same_point? && game_point_pair.reach(3)
      DEUCE
    elsif game_point_pair.reach(4) && game_point_pair.diff == 1
      "#{ADVANTAGE} #{players[game_point_pair.large_point_id]}"
    else
      game_point_pair.points.map { |point| GAME_POINT_NAMES[point] }.join('-')
    end.to_s
  end
end
