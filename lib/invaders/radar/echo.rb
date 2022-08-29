# frozen_string_literal: true

module Invaders
  module Radar
    class Echo
      attr_reader :v_pos, :h_pos, :invader

      attr_accessor :accuracy

      def initialize(v_pos, h_pos, invader, accuracy)
        @v_pos = v_pos
        @h_pos = h_pos
        @invader = invader
        @accuracy = accuracy
      end

      def blip?(abs_v_pos, abs_h_pos)
        relative_invader_v_pos = abs_v_pos - v_pos
        relative_invader_h_pos = abs_h_pos - h_pos
        return false if relative_invader_v_pos.negative? || relative_invader_h_pos.negative?

        invader.echo?(relative_invader_v_pos, relative_invader_h_pos)
      end

      def collides?(other)
        v_range.map do |abs_v_pos|
          h_range.map do |abs_h_pos|
            blip?(abs_v_pos, abs_h_pos) && other.blip?(abs_v_pos, abs_h_pos)
          end
        end.flatten.any?
      end

      def ==(other)
        self.class == other.class &&
          @v_pos == other.v_pos &&
          @h_pos == other.h_pos &&
          @invader == other.invader &&
          @accuracy == other.accuracy
      end

      private

      def v_range
        (v_pos..(v_pos + invader.height - 1))
      end

      def h_range
        (h_pos..(h_pos + invader.width - 1))
      end
    end
  end
end
