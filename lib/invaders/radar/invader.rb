# frozen_string_literal: true

module Invaders
  module Radar
    class Invader
      attr_reader :name, :sample

      def self.build(name)
        new(FileLoad.new("lib/invaders/radar/support/#{name}.txt").call, name)
      end

      def initialize(invader_sample, name)
        @sample = invader_sample
        @name = name
      end

      def echo?(v_pos, h_pos)
        @sample[v_pos] ? @sample[v_pos][h_pos] == "o" : false
      end

      def match?(a_sample)
        a_sample == @sample
      end

      def height
        @sample.length
      end

      def width
        @sample.first.length
      end
    end
  end
end
