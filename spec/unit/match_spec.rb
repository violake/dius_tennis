# frozen_string_literal: true

require 'spec_helper'
require 'match'

describe Match do
  let(:player_1) { 'player 1' }
  let(:player_2) { 'player 2' }

  subject { described_class.new(player_1, player_2) }

  context 'player 1 won a point' do
    before { subject.point_won_by(player_1) }

    it 'should get 15-0 game score' do
      expect(subject.score).to eq '0-0, 15-0'
    end
  end

  context 'player 2 won a point' do
    before { subject.point_won_by(player_2) }

    it 'should get 0-15 game score' do
      expect(subject.score).to eq '0-0, 0-15'
    end
  end

  context 'player 1 won 3 points and player 2 won 1 point' do
    before do
      player_won_points(subject, player_1, 3)
      player_won_points(subject, player_2, 1)
    end

    it 'should get 40-15 game score' do
      expect(subject.score).to eq '0-0, 40-15'
    end
  end

  context 'both player won 3 points' do
    before do
      player_won_points(subject, player_1, 3)
      player_won_points(subject, player_2, 3)
    end

    it 'should get Deuce game score' do
      expect(subject.score).to eq '0-0, Deuce'
    end
  end

  context 'one player won 1 point after deuce' do
    before do
      player_won_points(subject, player_1, 3)
      player_won_points(subject, player_2, 3)
    end

    it 'should get advangate game score for player_1' do
      player_won_points(subject, player_1, 1)
      expect(subject.score).to eq '0-0, Advantage player 1'
    end

    it 'should get advangate game score for player_2' do
      player_won_points(subject, player_2, 1)
      expect(subject.score).to eq '0-0, Advantage player 2'
    end
  end

  context 'one player won 1 point after the opponant advantage' do
    before do
      player_won_points(subject, player_1, 3)
      player_won_points(subject, player_2, 3)
      player_won_points(subject, player_1, 1)
      player_won_points(subject, player_2, 1)
    end

    it 'should get Deuce game score' do
      expect(subject.score).to eq '0-0, Deuce'
    end
  end

  private

  def player_won_points(match, player_name, points)
    points.times do
      match.point_won_by(player_name)
    end
  end
end
