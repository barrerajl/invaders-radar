# frozen_string_literal: true

require "spec_helper"

RSpec.describe Invaders::Radar::Echo do
  describe "#blip?" do
    # Testing pattern
    #   012345
    # 0 ------
    # 1 ------
    # 2 ----o-
    # 3 ---o-o
    # 4 ------
    # 5 ------
    #
    # positive_hits(v,h): (2,4), (3,3), (3,5)

    subject(:hit) { described_class.new(2, 3, invader, 1).blip?(crab_v_pos, crab_h_pos) }

    let(:invader) { Invaders::Radar::Invader.new(["-o-", "o-o"], :test_invader) }

    (0..5).each do |row|
      (0..5).each do |col|
        if (row == 2 && col == 4) || (row == 3 && col == 3) || (row == 3 && col == 5)
          context "with a point in the invader col: #{col}, row: #{row}" do
            let(:crab_v_pos) { row }
            let(:crab_h_pos) { col }

            it "hits the invader" do
              expect(hit).to be true
            end
          end
        else
          context "with a point outside the invader col: #{col}, row: #{row}" do
            let(:crab_v_pos) { row }
            let(:crab_h_pos) { col }

            it "does NOT hit the invader" do
              expect(hit).to be false
            end
          end
        end
      end
    end
  end

  describe "#collides?" do
    subject(:collision) { described_class.new(2, 3, invader, 1).collides?(other) }

    context "with separated invaders" do
      # Testing pattern
      #   012345
      # 0 -o----
      # 1 o-o---
      # 2 ----o-
      # 3 ---o-o
      # 4 ------
      # 5 ------
      #
      # positive_hits(v,h): (2,4), (3,3), (3,5)

      let(:invader) { Invaders::Radar::Invader.new(["-o-", "o-o"], :test_invader) }
      let(:other) { described_class.new(0, 0, invader, 1) }

      it "does not collide" do
        expect(collision).to be false
      end
    end

    context "with an invaders near other invader" do
      # Testing pattern
      #   012345
      # 0 ------
      # 1 --o---
      # 2 -o-oo-
      # 3 ---o-o
      # 4 ------
      # 5 ------
      #
      # positive_hits(v,h): (2,4), (3,3), (3,5)

      let(:invader) { Invaders::Radar::Invader.new(["-o-", "o-o"], :test_invader) }
      let(:other) { described_class.new(1, 1, invader, 1) }

      it "does not collide" do
        expect(collision).to be false
      end
    end

    context "with an invaders collinding other invader" do
      # Testing pattern
      #   012345
      # 0 ------
      # 1 ---o--
      # 2 --o-o-
      # 3 ---o-o
      # 4 ------
      # 5 ------
      #
      # positive_hits(v,h): (2,4), (3,3), (3,5)

      let(:invader) { Invaders::Radar::Invader.new(["-o-", "o-o"], :test_invader) }
      let(:other) { described_class.new(1, 2, invader, 1) }

      it "collides with other invader" do
        expect(collision).to be true
      end
    end
  end
end
