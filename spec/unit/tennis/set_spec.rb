# frozen_string_literal: true

require 'spec_helper'
require 'tennis/set'

describe Tennis::Set do
  let(:player1_id) { 0 }
  let(:player2_id) { 1 }

  subject { described_class.new }

  describe 'add_game_point' do
    context 'set start' do
      before do
        set_add_game_point(subject, player1_id, 1)
      end

      it { expect(subject.points).to eq [0, 0] }
      it { expect(subject.current_game.points).to eq [1, 0] }
    end

    context 'current game complete' do
      before do
        set_add_game_point(subject, player1_id, 3)
        set_add_game_point(subject, player2_id, 2)
        set_add_game_point(subject, player1_id, 1)
      end

      it { expect(subject.points).to eq [1, 0] }
      it { expect(subject.current_game).to be_nil }
    end

    context 'set with several games completed' do
      before do
        set_add_complete_games(subject, player1_id, 2)
        set_add_complete_games(subject, player2_id, 3)
        set_add_game_point(subject, player1_id, 2)
      end

      it { expect(subject.points).to eq [2, 3] }
      it { expect(subject.current_game.points).to eq [2, 0] }
    end
  end

  describe 'completed?' do
    context 'set point is not reach winning point(6)' do
      before do
        set_add_complete_games(subject, player1_id, 2)
        set_add_complete_games(subject, player2_id, 3)
      end

      it { expect(subject.completed?).to eq false }
    end

    context 'set point reaches winning point(6) but diff = 1' do
      before do
        set_add_complete_games(subject, player1_id, 5)
        set_add_complete_games(subject, player2_id, 6)
      end

      it { expect(subject.completed?).to eq false }
    end

    context 'set point reaches winning point(6) but diff > 1' do
      before do
        set_add_complete_games(subject, player1_id, 4)
        set_add_complete_games(subject, player2_id, 6)
      end

      it { expect(subject.completed?).to eq true }
    end

    context 'set point reaches final winning point(7)' do
      before do
        set_add_complete_games(subject, player1_id, 5)
        set_add_complete_games(subject, player2_id, 6)
        set_add_complete_games(subject, player1_id, 1)
        set_add_game_point(subject, player1_id, 7)
      end

      it { expect(subject.completed?).to eq true }
    end
  end

  private

  def set_add_game_point(set, player_id, points)
    points.times do
      set.add_game_point(player_id)
    end
  end

  def set_add_complete_games(set, player_id, games)
    (games * 4).times do
      set.add_game_point(player_id)
    end
  end
end
