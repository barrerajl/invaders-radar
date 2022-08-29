# frozen_string_literal: true

require "pastel"

module Invaders
  module Radar
    module Printers
      class Echos
        def initialize(radar_sample, echos, accuracy)
          @pastel = Pastel.new
          @echos = echos
          @radar_sample = radar_sample
          @accuracy = accuracy
        end

        def to_stdout
          @radar_sample.each_with_index do |row, v_pos|
            row.chars.each_with_index do |char, h_pos|
              print_char(char, v_pos, h_pos)
            end
            print "\n"
          end
        end

        private

        def print_char(char, v_pos, h_pos)
          echo = @echos.find { |e| e.blip?(v_pos, h_pos) && e.accuracy >= @accuracy }
          if echo
            print @pastel.decorate(char, *char_decorator(echo))
          else
            print char
          end
        end

        def char_decorator(echo)
          color = (INVADER_COLORS[echo.invader.name] if echo.accuracy >= @accuracy)

          dim = (:dim if echo.accuracy < 1 && echo.accuracy >= @accuracy)

          [color, dim].compact
        end
      end
    end
  end
end
