# frozen_string_literal: true

require_relative "detectors/base_detector"
require_relative "detectors/exact"
require_relative "detectors/shape"
require_relative "echo"
require_relative "file_load"
require_relative "invader"
require_relative "printers/invader"
require_relative "printers/printers"
require_relative "printers/echos"
require_relative "version"

module Invaders
  module Radar
    class Radar
      INVADERS = %i[crab squid].freeze

      attr_reader :invaders

      def initialize(radar_sample, detection_strategy)
        @radar_sample = radar_sample
        @invaders = load_invaders
        @detection_strategy = detection_strategy
      end

      def detect_echos
        @invaders.map do |invader|
          detector_class.new(@radar_sample, invader).detect
        end.flatten
      end

      private

      def detector_class
        case @detection_strategy
        when :shape
          Invaders::Radar::Detectors::Shape
        else
          Invaders::Radar::Detectors::Exact
        end
      end

      def load_invaders
        Invaders::Radar::Radar::INVADERS.map do |invader|
          Invaders::Radar::Invader.build(invader)
        end
      end
    end
  end
end
