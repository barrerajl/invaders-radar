# frozen_string_literal: true

require "pastel"

module Invaders
  module Radar
    module Printers
      class Invader
        attr_reader :invader

        def initialize(invader)
          @color = Invaders::Radar::Printers::INVADER_COLORS[invader.name]
          @pastel = Pastel.new
          @invader = invader
        end

        def to_stdout
          @invader.sample.each do |row|
            row.chars.each do |char|
              print_char(char)
            end
            print "\n"
          end
        end

        def invader_name
          @invader.name
        end

        private

        def print_char(char)
          if char == "o" && @color
            print @pastel.decorate(char, @color)
          else
            print char
          end
        end
      end
    end
  end
end
