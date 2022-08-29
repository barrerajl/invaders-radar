# frozen_string_literal: true

require "spec_helper"

RSpec.describe Invaders::Radar::Printers::Echos do
  let(:name) { :test_invader }
  let(:echos) { [Invaders::Radar::Echo.new(1, 1, Invaders::Radar::Invader.new(["o"], name), invader_accuracy)] }
  let(:accuracy) { 1 }
  let(:invader_accuracy) { 1 }

  describe "#to_stdout" do
    subject(:printed_echos) { described_class.new(radar_sample, echos, accuracy).to_stdout }

    let(:radar_sample) { ["---", "-o-", "---"] }

    it "prints the sample" do
      expect { printed_echos }.to output("#{radar_sample.join("\n")}\n").to_stdout
    end

    context "with a green colored name" do
      let(:name) { :crab }

      it "prints the invader with greeb" do
        expect { printed_echos }.to output("---\n-\e[32mo\e[0m-\n---\n").to_stdout
      end
    end

    context "with a red colored name" do
      let(:name) { :squid }

      it "prints the invader with red" do
        expect { printed_echos }.to output("---\n-\e[31mo\e[0m-\n---\n").to_stdout
      end
    end

    context "with a lower accuracy" do
      let(:accuracy) { 0.8 }
      let(:invader_accuracy) { 0.8 }

      it "prints a dimmed invader" do
        expect { printed_echos }.to output("---\n-\e[2mo\e[0m-\n---\n").to_stdout
      end
    end

    context "with a higher accuracy than the invader" do
      let(:accuracy) { 0.9 }
      let(:invader_accuracy) { 0.8 }

      it "prints the sample" do
        expect { printed_echos }.to output("#{radar_sample.join("\n")}\n").to_stdout
      end
    end
  end
end
