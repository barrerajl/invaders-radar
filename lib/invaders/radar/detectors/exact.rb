# frozen_string_literal: true

module Invaders
  module Radar
    module Detectors
      class Exact < BaseDetector
        private

        def detect_partial(v_pos, h_pos, partial_radar_sample)
          Invaders::Radar::Echo.new(v_pos, h_pos, @invader, 1) if @invader.match?(partial_radar_sample)
        end
      end
    end
  end
end
