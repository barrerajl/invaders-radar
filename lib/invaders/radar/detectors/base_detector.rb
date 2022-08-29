# frozen_string_literal: true

module Invaders
  module Radar
    module Detectors
      class BaseDetector
        def initialize(radar_sample, invader)
          @radar_sample = radar_sample
          @invader = invader
        end

        def detect
          detect_partials
        end

        private

        def column_limit
          @radar_sample.length - @invader.height
        end

        def detect_partial(v_pos, h_pos, partial_radar_sample)
          raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
        end

        def detect_partials
          (0..column_limit).map do |v_pos|
            (0..row_limit).map do |h_pos|
              detect_partial(v_pos, h_pos, partial_sample(v_pos, h_pos))
            end
          end.flatten.compact
        end

        def partial_sample(v_pos, h_pos)
          @radar_sample[v_pos..(v_pos + @invader.height - 1)].map do |column|
            column[h_pos..(h_pos + @invader.width - 1)]
          end
        end

        def row_limit
          @radar_sample.first.length - @invader.width
        end
      end
    end
  end
end
