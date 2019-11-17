# frozen_string_literal: true

require 'tennis/set'

class Match
  attr_reader :players, :set, :current_game

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
                            ", #{set.current_game.score(players)}"
                          else
                            ''
                          end
  end
end
