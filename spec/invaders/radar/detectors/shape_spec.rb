# frozen_string_literal: true

require "spec_helper"

RSpec.describe Invaders::Radar::Detectors::Shape do
  describe "#detect" do
    subject(:detection_result) { described_class.new(radar_sample, invader).detect }

    let(:invader) { Invaders::Radar::Invader.new(invader_pattern, :test_invader) }

    context "with a minimal pattern" do
      let(:invader_pattern) { ["o"] }
      let(:radar_sample) do
        [
          "---",
          "-o-",
          "---"
        ]
      end

      it "detects the invader" do
        expect(detection_result).to eq [Invaders::Radar::Echo.new(1, 1, invader, 1)]
      end
    end

    context "with a complex pattern" do
      let(:invader_pattern) { ["-o-", "o-o"] }
      let(:radar_sample) do
        [
          "-----",
          "-----",
          "--o--",
          "-o-o-",
          "-----"
        ]
      end

      it "detects the invader" do
        expect(detection_result).to eq [Invaders::Radar::Echo.new(2, 1, invader, 1)]
      end
    end

    context "with invader intruding on other invader pattern" do
      let(:invader_pattern) { ["-o-", "o-o"] }
      let(:radar_sample) do
        [
          "-----",
          "---o-",
          "-oo-o",
          "o-o--",
          "-----"
        ]
      end

      it "detects both invaders" do
        expect(detection_result).to eq [Invaders::Radar::Echo.new(1, 2, invader, 1),
                                        Invaders::Radar::Echo.new(2, 0, invader, 1)]
      end
    end

    context "with invader colliding on other invader pattern" do
      let(:invader_pattern) { ["-o-", "o-o"] }
      let(:radar_sample) do
        [
          "-----",
          "--o-",
          "-o-o-",
          "o-o--",
          "-----"
        ]
      end

      it "detects both invaders" do
        expect(detection_result).to eq [Invaders::Radar::Echo.new(1, 1, invader, 1),
                                        Invaders::Radar::Echo.new(2, 0, invader, 0.8)]
      end
    end
  end
end
