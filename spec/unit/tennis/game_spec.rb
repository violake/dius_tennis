# frozen_string_literal: true

require 'spec_helper'
require 'tennis/game'

describe Tennis::Game do
  let(:player1_id) { 0 }
  let(:player2_id) { 1 }

  describe 'ordinary game' do
    subject { described_class.new }

    describe 'add point' do
      context 'game start' do
        before do
          subject.add_point(player1_id)
          subject.add_point(player1_id)
        end

        it { expect(subject.points).to eq [2, 0] }
        it { expect(subject.complete?).to eq false }
      end

      context 'game points reaches winning point(4) but diff = 1' do
        before do
          game_add_point(subject, player1_id, 3)
          game_add_point(subject, player2_id, 3)
          game_add_point(subject, player1_id, 1)
        end

        it { expect(subject.points).to eq [4, 3] }
        it { expect(subject.complete?).to eq false }
      end

      context 'game points is above winning point but diff = 1' do
        before do
          game_add_point(subject, player1_id, 3)
          game_add_point(subject, player2_id, 3)
          game_add_point(subject, player1_id, 1)
          game_add_point(subject, player2_id, 1)
          game_add_point(subject, player1_id, 1)
        end

        it { expect(subject.points).to eq [5, 4] }
        it { expect(subject.complete?).to eq false }
      end

      context 'game points reaches winning point and diff > 1' do
        before do
          game_add_point(subject, player1_id, 2)
          game_add_point(subject, player2_id, 4)
        end

        it { expect(subject.points).to eq [2, 4] }
        it { expect(subject.complete?).to eq true }
      end

      context 'game points is above winning point and diff > 1' do
        before do
          game_add_point(subject, player1_id, 3)
          game_add_point(subject, player2_id, 4)
          game_add_point(subject, player1_id, 3)
        end

        it { expect(subject.points).to eq [6, 4] }
        it { expect(subject.complete?).to eq true }
      end
    end

    describe 'winner_id' do
      context 'game complete' do
        before do
          game_add_point(subject, player1_id, 4)
        end

        it { expect(subject.winner_id).to eq 0 }
      end

      context 'game not complete' do
        before do
          game_add_point(subject, player1_id, 2)
        end

        it { expect(subject.winner_id).to be_nil }
      end
    end
  end

  describe 'tie break game' do
    subject { described_class.new(tie_break: true) }

    context 'game should not complete as ordinary game' do
      before do
        game_add_point(subject, player1_id, 2)
        game_add_point(subject, player2_id, 4)
      end

      it { expect(subject.points).to eq [2, 4] }
      it { expect(subject.complete?).to eq false }
    end

    context 'points reaches winning point(7) and diff = 1' do
      before do
        game_add_point(subject, player1_id, 6)
        game_add_point(subject, player2_id, 7)
      end

      it { expect(subject.points).to eq [6, 7] }
      it { expect(subject.complete?).to eq false }
    end

    context 'points is above winning point(7) and diff = 1' do
      before do
        game_add_point(subject, player1_id, 6)
        game_add_point(subject, player2_id, 7)
        game_add_point(subject, player1_id, 2)
      end

      it { expect(subject.points).to eq [8, 7] }
      it { expect(subject.complete?).to eq false }
    end

    context 'points reaches winning point(7) and diff > 1' do
      before do
        game_add_point(subject, player1_id, 5)
        game_add_point(subject, player2_id, 7)
      end

      it { expect(subject.points).to eq [5, 7] }
      it { expect(subject.complete?).to eq true }
    end

    context 'points is over winning point(7) and diff > 1' do
      before do
        game_add_point(subject, player1_id, 6)
        game_add_point(subject, player2_id, 7)
        game_add_point(subject, player1_id, 3)
      end

      it { expect(subject.points).to eq [9, 7] }
      it { expect(subject.complete?).to eq true }
    end
  end

  private

  def game_add_point(game, player_id, points)
    points.times do
      game.add_point(player_id)
    end
  end
end
