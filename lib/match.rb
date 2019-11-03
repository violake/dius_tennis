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
    raise StandardError, 'Match is over!' if set_complete?

    add_game_point(players.index(player_name))

    update_set
  end

  def score
    if set_complete?
      set.join('-') + ", #{players[set.index(set.max)]} win"
    elsif current_game
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

  def update_set
    if current_game_complete?
      set[current_game.index(current_game.max)] += 1
      @current_game = nil
    end
  end

  def set_complete?
    set.max >= 6 && (set[0] - set[1]).abs > 1 || set.max == 7
  end

  def tie_break?
    set.uniq.count == 1 && set[0] == 6
  end

  def current_game_complete?
    tie_break? ? game_complete?(7) : game_complete?(4)
  end

  def game_complete?(game_point)
    current_game && current_game.max >= game_point && (current_game[0] - current_game[1]).abs > 1
  end

  def create_new_game
    @current_game = [0, 0]
    @games << @current_game
  end

  def current_game_to_s
    tie_break? ? current_game.join('-') : game_to_s
  end

  def game_to_s
    if current_game.uniq.count == 1 && current_game[0] >= 3
      'Deuce'
    elsif current_game.max > 3 && (current_game[0] - current_game[1]).abs == 1
      "Advantage #{players[current_game.index(current_game.max)]}"
    else
      current_game.map { |point| GAME_POINT_NAMES[point] }.join('-')
    end
  end
end
