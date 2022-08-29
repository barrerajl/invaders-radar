# frozen_string_literal: true

require "spec_helper"

RSpec.describe "exe/invaders-radar" do
  describe "exe" do
    before do
      allow(Invaders::Radar::RadarCLI).to receive(:detect_invaders)
    end

    it "calls radar cli" do
      load %(./exe/invaders-radar)
      expect(Invaders::Radar::RadarCLI).to have_received(:detect_invaders)
    end
  end
end
