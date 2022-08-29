# frozen_string_literal: true

module Invaders
  module Radar
    class FileLoad
      FILE_LIMITER = "~~~~"

      def initialize(file)
        @file = file
      end

      def call
        invader = []

        File.foreach(@file) do |line|
          line = line.gsub(/\r|\n|\s+/, "")

          line = nil if line.empty?
          line = nil if line == FILE_LIMITER

          invader << line
        end

        invader.compact
      end
    end
  end
end
