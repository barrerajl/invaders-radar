# frozen_string_literal: true

require "spec_helper"

RSpec.describe Invaders::Radar::Detectors::BaseDetector do
  describe "#detect" do
    subject(:detect) { detector.detect }

    let(:detector) { described_class.new(radar_sample, invader) }
    let(:radar_sample) { ["-"] }
    let(:invader) { Invaders::Radar::Invader.new(["o"], :test_invader) }

    context "when detect method calls detect_partial method so other classes can implement it" do
      before do
        allow(detector).to receive(:detect_partial)
      end

      it "calls detect partial" do
        detect
        expect(detector).to have_received(:detect_partial)
      end
    end

    context "when not implemented detect partials" do
      it "raises an exception" do
        expect { detect }.to raise_exception NotImplementedError
      end
    end
  end
end
