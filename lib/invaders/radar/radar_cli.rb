# frozen_string_literal: true

require "slop"
require "pastel"

require_relative "radar"

module Invaders
  module Radar
    class RadarCLI
      STRATEGY_MESSAGE = "Detection Strategy: Can choose between different strategies exact|shape\n  " \
                         "* Exact(default): Will match the exact invader pattern (positive and negative)\n  " \
                         "* Shape: Will only look for positive hits of the invader.\n    " \
                         "Accuracy for collisions lowered to 0.8"

      def self.detect_invaders(args)
        new(args).detect_invaders
      end

      def initialize(args)
        parser = Slop::Parser.new(command_options)
        @options = parser.parse(args).to_hash
        radar_sample
      rescue Slop::MissingArgument, NoMethodError, Errno::ENOENT
        @options = {}
      ensure
        @pastel = Pastel.new
      end

      def detect_invaders
        if radar_sample
          print_invaders_header
          print_radar_results
          exit_radar 0
        else
          radar_sample_needed
        end
      end

      private

      def print_radar_results
        Invaders::Radar::Printers::Echos.new(
          radar_sample,
          radar.detect_echos,
          accuracy
        ).to_stdout
      end

      def command_options
        Slop::Options.new.tap do |opts|
          opts.banner = "usage: invaders-radar [options] ..."
          opts.separator ""
          opts.separator "detection option:"
          opts.string "-r", "--radar-sample", "Radar sample file for detection"
          opts.symbol "-s", "--strategy", STRATEGY_MESSAGE, default: :exact
          opts.float "-a", "--accuracy",
                     "For fuzzy strategies prints hits dimmed: * Shape: (0.8)", default: 1
        end
      end

      def print_invaders_header
        puts "Loading invaders:"
        invader_printers.each do |printer|
          puts "Loading #{printer.invader_name} invader:"
          printer.to_stdout
          puts ""
        end
      end

      def invader_printers
        radar.invaders.map do |invader|
          Invaders::Radar::Printers::Invader.new(invader)
        end
      end

      def radar
        @radar ||= Invaders::Radar::Radar.new(radar_sample, detection_strategy)
      end

      def radar_sample
        @radar_sample ||= @options[:radar_sample] ? FileLoad.new(@options[:radar_sample]).call : nil
      end

      def accuracy
        @options[:accuracy]
      end

      def detection_strategy
        @options[:strategy]
      end

      def radar_sample_needed
        puts @pastel.red("A radar sample is needed to analyse!")
        puts command_options
        exit_radar 1
      end

      def exit_radar(code)
        exit code
      end
    end
  end
end
