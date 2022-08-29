# frozen_string_literal: true

module Invaders
  module Radar
    module Detectors
      class Shape < BaseDetector
        private

        def detect_partial(v_pos, h_pos, partial_sample)
          echos_shape = create_shape(partial_sample)
          return Invaders::Radar::Echo.new(v_pos, h_pos, @invader, 1) if @invader.match?(echos_shape)
        end

        def detect_partials
          echos = super

          lower_collisions_accuracy(map_collisions(echos))

          echos
        end

        def map_collisions(echos)
          echos.map do |echo|
            { echo => echos.select { |other| other == echo ? false : other.collides?(echo) } }
          end.reduce({}, :merge)
        end

        def create_shape(partial_sample)
          partial_sample.map.with_index do |row, col_index|
            row.chars.map.with_index do |char, row_index|
              if char == "o"
                @invader.echo?(col_index, row_index) ? "o" : "-"
              else
                "-"
              end
            end.join
          end
        end

        def lower_collisions_accuracy(collisions_map)
          collision_echos = collisions_map.keys
          collisions_map.map do |echo, collisions|
            next unless collision_echos.include?(echo)

            collision_echos -= collisions
            collisions.each do |colliding_echo|
              colliding_echo.accuracy = 0.8
            end
          end
        end
      end
    end
  end
end
