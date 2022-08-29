# frozen_string_literal: true

require "spec_helper"

RSpec.describe Invaders::Radar::FileLoad do
  describe "#load" do
    subject(:load_invader) { described_class.new("spec/support/crab.txt").call }

    context "with an existing file" do
      let(:invader) do
        [
          "--o---o--",
          "o--ooo--o",
          "o-ooooo-o",
          "ooo-o-ooo",
          "-ooooooo-",
          "--o---o--",
          "-o-----o-"
        ]
      end

      it "loads the invader" do
        expect(load_invader).to eq invader
      end
    end
  end
end
