# frozen_string_literal: true

require "spec_helper"

RSpec.describe Invaders::Radar::Printers::Invader do
  let(:invader_sample) { ["o"] }
  let(:invader) { Invaders::Radar::Invader.new(invader_sample, name) }
  let(:name) { :test_invader }

  describe "#to_stdout" do
    subject(:printed_invader) { described_class.new(invader).to_stdout }

    it "prints the invader" do
      expect { printed_invader }.to output("#{invader_sample.join("\n")}\n").to_stdout
    end

    context "with a green colored name" do
      let(:name) { :crab }

      it "prints the invader with color" do
        expect { printed_invader }.to output("\e[32mo\e[0m\n").to_stdout
      end
    end

    context "with a red colored name" do
      let(:name) { :squid }

      it "prints the invader with color" do
        expect { printed_invader }.to output("\e[31mo\e[0m\n").to_stdout
      end
    end
  end

  describe "#invader_name" do
    subject(:invader_name) { described_class.new(invader).invader_name }

    it "returns the invader name" do
      expect(invader_name).to eq :test_invader
    end
  end
end
