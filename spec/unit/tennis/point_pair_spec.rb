# frozen_string_literal: true

require 'spec_helper'
require 'tennis/point_pair'

describe Tennis::PointPair do
  let(:value) { 3 }

  subject { described_class.new }

  context 'points' do
    before { subject.add_one_point(0) }

    it { expect(subject.points[0]).to eq 1 }

    it 'should not be readonly' do
      subject.points[0] += 1
      expect(subject.points[0]).to eq 1
    end
  end

  context 'add_one_point' do
    before { subject.add_one_point(0) }

    it { expect(subject.points[0]).to eq 1 }
  end

  context 'reach' do
    before do
      value.times { subject.add_one_point(0) }
    end

    it { expect(subject.reach(value)).to be_truthy }
    it { expect(subject.reach(value + 1)).to be_falsey }
  end

  context 'large_point_id' do
    before do
      value.times { subject.add_one_point(0) }
      (value + 1).times { subject.add_one_point(1) }
    end

    it { expect(subject.large_point_id).to eq 1 }
  end

  context 'diff' do
    let(:diff) { value - 1 }

    before do
      value.times { subject.add_one_point(0) }
      subject.add_one_point(1)
    end

    it { expect(subject.diff).to eq diff }
  end

  context 'to_s' do
    before do
      value.times { subject.add_one_point(0) }
    end

    it { expect(subject.to_s).to eq "#{value}-0" }
  end
end
