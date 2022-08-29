# frozen_string_literal: true

require "spec_helper"

RSpec.describe Invaders::Radar::Invader do
  describe ".load" do
    subject(:load_invader) { described_class.build(:crab) }

    let(:crab_sample) { Invaders::Radar::FileLoad.new("lib/invaders/radar/support/crab.txt").call }

    it "loads a new invader instance" do
      expect(load_invader).to be_an_instance_of(described_class)
    end

    it "names the invader" do
      expect(load_invader.name).to eq(:crab)
    end

    it "loads the invader sample" do
      expect(load_invader.match?(crab_sample)).to be true
    end
  end

  describe "#echo?" do
    subject(:invader_echo) { described_class.new(invader_sample, :test_invader).echo?(v_pos, h_pos) }

    let(:invader_sample) { ["-o-", "o-o"] }

    context "with a hitting point" do
      let(:v_pos) { 0 }
      let(:h_pos) { 1 }

      it "returns echo is true" do
        expect(invader_echo).to be true
      end
    end

    context "with a non hitting point" do
      let(:v_pos) { 1 }
      let(:h_pos) { 1 }

      it "returns echo is true" do
        expect(invader_echo).to be false
      end
    end

    context "with a point out of rage?" do
      let(:v_pos) { 7 }
      let(:h_pos) { 7 }

      it "returns echo is true" do
        expect(invader_echo).to be false
      end
    end
  end

  describe "match?" do
    subject(:matches_invader) { described_class.new(invader_sample, :test_invader).match?(sample) }

    let(:invader_sample) { ["-o-", "o-o"] }

    context "with the same sample" do
      let(:sample) { ["-o-", "o-o"] }

      it "matches the sample" do
        expect(matches_invader).to be true
      end
    end

    context "with a different sample" do
      let(:sample) { ["-oo", "ooo"]  }

      it "does not match the sample" do
        expect(matches_invader).to be false
      end
    end
  end

  describe "#height" do
    subject(:invader_height) { described_class.new(invader_sample, :test_invader).height }

    let(:invader_sample) { ["-o-", "o-o"] }

    it "returns invader height" do
      expect(invader_height).to be 2
    end
  end

  describe "#width" do
    subject(:invader_width) { described_class.new(invader_sample, :test_invader).width }

    let(:invader_sample) { ["-o-", "o-o"] }

    it "returns invader width" do
      expect(invader_width).to be 3
    end
  end
end
