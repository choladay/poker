require 'rails_helper'

RSpec.describe Card, type: :model do
  describe "<=>" do
    it "should compare #rank_strength against 2 differently strong Cards" do
      lower_card = Card.new(rank_strength: 0)
      higher_card = Card.new(rank_strength: 1)

      expect(lower_card).to be < higher_card
    end

    it "should equate #rank_strength when comparing identically strong Cards" do
      lower_card = Card.new(rank_strength: 0)
      lower_card_dup = Card.new(rank_strength: 0)

      expect(lower_card).to be == lower_card_dup
    end
  end
end
