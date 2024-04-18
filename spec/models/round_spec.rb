require 'rails_helper'

RSpec.describe Round, type: :model do
  describe "#parse_hand!" do
    it "should take an Array of strings and find them in the deck" do
      round = Round.new
      round.parse_hand!(%w(QC KC 3S JC KD), 1)

      expect(round.hands.length).to eq(1)
      expect(round.hands.first.cards.length).to eq(5)
      round.hands.first.cards.each do |card|
        expect(card).to be_a(Card)
      end
    end
  end
end
