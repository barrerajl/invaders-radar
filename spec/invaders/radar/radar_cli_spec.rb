# frozen_string_literal: true

require "spec_helper"

RSpec.describe Invaders::Radar::RadarCLI do
  let(:command_options) do
    "\e[31mA radar sample is needed to analyse!\e[0m\n" \
      "usage: invaders-radar [options] ...\n" \
      "\n" \
      "detection option:\n    " \
      "-r, --radar-sample  Radar sample file for detection\n    " \
      "-s, --strategy      Detection Strategy: Can choose between different strategies exact|shape\n  " \
      "* Exact(default): Will match the exact invader pattern (positive and negative)\n  " \
      "* Shape: Will only look for positive hits of the invader.\n    " \
      "Accuracy for collisions lowered to 0.8\n    " \
      "-a, --accuracy      For fuzzy strategies prints hits dimmed: * Shape: (0.8)\n"
  end

  describe ".detect_invaders" do
    subject(:detect_invaders) { described_class.detect_invaders([]) }

    it "calls radar_cli detect_invaders instance" do
      radar_cli = instance_double(described_class)
      allow(radar_cli).to receive(:detect_invaders)
      allow(described_class).to receive(:new).and_return(radar_cli)

      detect_invaders

      expect(radar_cli).to have_received(:detect_invaders)
    end
  end

  describe "#detect_invaders" do
    subject(:detect_invaders) { radar_cli.detect_invaders }

    let(:radar_cli) { described_class.new(args) }

    context "without arguments" do
      let(:args) { nil }

      it "prints the command description" do
        allow(radar_cli).to receive(:radar_sample_needed)

        detect_invaders

        expect(radar_cli).to have_received(:radar_sample_needed)
      end
    end

    context "with empty argument" do
      let(:args) { "" }

      it "prints the command description" do
        allow(radar_cli).to receive(:radar_sample_needed)

        detect_invaders

        expect(radar_cli).to have_received(:radar_sample_needed)
      end
    end

    context "with an unnamed" do
      let(:args) { ["-r", ""] }

      it "prints the command description" do
        allow(radar_cli).to receive(:radar_sample_needed)

        detect_invaders

        expect(radar_cli).to have_received(:radar_sample_needed)
      end
    end

    context "with non existing radar sample" do
      let(:args) { ["-r", "bogus_name"] }

      it "prints the command description" do
        allow(radar_cli).to receive(:radar_sample_needed)

        detect_invaders

        expect(radar_cli).to have_received(:radar_sample_needed)
      end
    end

    describe "command header" do
      let(:args) { ["-r", "snapshot_example.txt"] }

      before do
        allow(radar_cli).to receive(:exit_radar)
        allow(radar_cli).to receive(:print_radar_results)
        allow(radar_cli).to receive(:puts)
      end

      it "prints the invaders header" do
        invader_printer = instance_double(Invaders::Radar::Printers::Invader, invader_name: :exact)
        allow(invader_printer).to receive(:to_stdout)
        allow(Invaders::Radar::Printers::Invader).to receive(:new).and_return(invader_printer)

        detect_invaders

        expect(invader_printer).to have_received(:to_stdout).twice
      end
    end

    describe "command result" do
      let(:args) { ["-r", "snapshot_example.txt"] }

      before do
        allow(radar_cli).to receive(:exit_radar)
        allow(radar_cli).to receive(:print_invaders_header)
      end

      it "prints the echos result" do
        echos_printer = instance_double(Invaders::Radar::Printers::Echos)
        allow(echos_printer).to receive(:to_stdout)
        allow(Invaders::Radar::Printers::Echos).to receive(:new).and_return(echos_printer)

        detect_invaders

        expect(echos_printer).to have_received(:to_stdout).once
      end
    end

    describe "command_options" do
      let(:args) { ["-r", "bogus_name"] }

      it "prints the command options" do
        expect { detect_invaders }.to raise_exception(SystemExit).and(output(command_options).to_stdout)
      end
    end

    describe "detection_strategy" do
      let(:args) { ["-r", "snapshot_example.txt", "-s", "exact"] }

      before do
        allow(radar_cli).to receive(:exit_radar)
        allow(Invaders::Radar::Radar).to receive(:new).and_call_original
        allow(radar_cli).to receive(:print_invaders_header)
        allow(Invaders::Radar::Printers::Echos).to(
          receive(:new).and_return(instance_double(Invaders::Radar::Printers::Echos, to_stdout: nil))
        )
      end

      it "send the strategy to the radar" do
        detect_invaders
        expect(Invaders::Radar::Radar).to have_received(:new).with(instance_of(Array), :exact)
      end
    end

    describe "accuracy" do
      let(:args) { ["-r", "snapshot_example.txt", "-s", "exact", "-a", "0.8"] }

      before do
        allow(radar_cli).to receive(:exit_radar)
        echos_printer = instance_double(Invaders::Radar::Printers::Echos, to_stdout: nil)
        allow(Invaders::Radar::Printers::Echos).to receive(:new).and_return(echos_printer)
        allow(radar_cli).to receive(:print_invaders_header)
      end

      it "send the strategy to the radar" do
        detect_invaders
        expect(Invaders::Radar::Printers::Echos).to have_received(:new).with(instance_of(Array),
                                                                             instance_of(Array), 0.8)
      end
    end
  end
end
