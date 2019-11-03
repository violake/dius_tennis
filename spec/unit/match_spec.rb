# frozen_string_literal: true

require 'spec_helper'
require 'match'

describe Match do
  let(:player_1) { 'player 1' }
  let(:player_2) { 'player 2' }

  subject { described_class.new(player_1, player_2) }

  context 'first game' do
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

    context 'one player won 4 points first' do
      before do
        player_won_points(subject, player_1, 3)
        player_won_points(subject, player_2, 2)
        player_won_points(subject, player_1, 1)
      end

      it 'should get 1-0 set score' do
        expect(subject.score).to eq '1-0'
      end
    end

    context 'one player won 1 point when he has advantage' do
      before do
        player_won_points(subject, player_1, 3)
        player_won_points(subject, player_2, 3)
        player_won_points(subject, player_1, 1)
        player_won_points(subject, player_1, 1)
      end

      it 'should get a 1-0 set score' do
        expect(subject.score).to eq '1-0'
      end
    end
  end

  context 'several games' do
    context 'player 1 win 2 games and player 2 win 3' do
      before do
        player_won_games(subject, player_1, 2)
        player_won_games(subject, player_2, 3)
      end

      it 'should get score 2-3' do
        expect(subject.score).to eq '2-3'
      end

      it 'should get score 2-3 15-0 if player 1 win one more point' do
        player_won_points(subject, player_1, 1)
        expect(subject.score).to eq '2-3, 15-0'
      end

      it 'should get score 2-3 0-15 if player 2 win one more point' do
        player_won_points(subject, player_2, 1)
        expect(subject.score).to eq '2-3, 0-15'
      end
    end
  end

  private

  def player_won_points(match, player_name, points)
    points.times do
      match.point_won_by(player_name)
    end
  end

  def player_won_games(match, player_name, games)
    (games * 4).times do
      match.point_won_by(player_name)
    end
  end
end
