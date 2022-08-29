# frozen_string_literal: true

require "spec_helper"

RSpec.describe Invaders::Radar::Radar do
  let(:radar_sample) { ["-"] }

  describe "#detect_echos" do
    subject(:detected_echos) { radar.detect_echos }

    let(:radar) { described_class.new(radar_sample, detection_strategy) }

    context "with exact strategy" do
      let(:detection_strategy) { :exact }

      it "uses the exact strategy detector for each invader" do
        detector = instance_double(Invaders::Radar::Detectors::Exact)
        allow(detector).to receive(:detect)
        allow(Invaders::Radar::Detectors::Exact).to receive(:new).and_return(detector)
        detected_echos
        expect(detector).to have_received(:detect).exactly(radar.invaders.count)
      end
    end

    context "with shape strategy" do
      let(:detection_strategy) { :shape }

      it "uses the shape strategy detector for each invader" do
        detector = instance_double(Invaders::Radar::Detectors::Shape)
        allow(detector).to receive(:detect)
        allow(Invaders::Radar::Detectors::Shape).to receive(:new).and_return(detector)
        detected_echos
        expect(detector).to have_received(:detect).exactly(radar.invaders.count)
      end
    end
  end

  describe "#invaders" do
    subject(:invaders_names) { described_class.new(radar_sample, :exact).invaders.map(&:name) }

    it "returns the invaders" do
      expect(invaders_names).to eq %i[crab squid]
    end
  end

  it "has a version number" do
    expect(Invaders::Radar::VERSION).not_to be_nil
  end
end
