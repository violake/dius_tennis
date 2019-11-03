# frozen_string_literal: true

require 'spec_helper'
require 'match'

describe Match do
  let(:player_1) { 'player 1' }
  let(:player_2) { 'player 2' }

  subject { described_class.new(player_1, player_2) }

  context 'one player win all games' do
    before do
      (6 * 4).times { subject.point_won_by(player_1) }
    end

    it { expect(subject.score).to eq '6-0, player 1 win' }
  end

  context 'both players win games and current game is complete' do
    before do
      (3 * 4).times { subject.point_won_by(player_1) }
      (2 * 4).times { subject.point_won_by(player_2) }
    end

    it { expect(subject.score).to eq '3-2' }
  end

  context 'both players win games and current game is playing' do
    before do
      (3 * 4).times { subject.point_won_by(player_1) }
      (5 * 4 + 2).times { subject.point_won_by(player_2) }
    end

    it { expect(subject.score).to eq '3-5, 0-30' }
  end

  context 'one player win set by tie break' do
    before do
      (5 * 4).times { subject.point_won_by(player_1) }
      (5 * 4).times { subject.point_won_by(player_2) }
      4.times { subject.point_won_by(player_1) }
      4.times { subject.point_won_by(player_2) }
      7.times { subject.point_won_by(player_2) }
    end

    it { expect(subject.score).to eq '6-7, player 2 win' }
  end
end
