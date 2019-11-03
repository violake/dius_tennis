# frozen_string_literal: true

class Match
  attr_reader :players, :set, :current_game

  GAME_POINT_NAMES = %w[0 15 30 40].freeze

  def initialize(player1_name, player2_name)
    @players = [player1_name, player2_name]
    @set = [0, 0]
    @games = []
    @current_game = nil
  end

  def point_won_by(player_name)
    add_game_point(players.index(player_name))
  end

  def score
    if current_game
      set.join('-') + ', ' + current_game_to_s
    else
      set.join('-')
    end
  end

  private

  def add_game_point(player_id)
    @current_game || create_new_game
    @current_game[player_id] += 1
  end

  def create_new_game
    @current_game = [0, 0]
    @games << @current_game
  end

  def current_game_to_s
    if current_game.uniq.count == 1 && current_game[0] >= 3
      'Deuce'
    elsif current_game.max > 3 && (current_game[0] - current_game[1]).abs == 1
      "Advantage #{players[current_game.index(current_game.max)]}"
    else
      current_game.map { |point| GAME_POINT_NAMES[point] }.join('-')
    end
  end
end
