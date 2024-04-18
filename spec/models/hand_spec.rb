require 'rails_helper'

# 1 High Card: Highest value card.
# 2 One Pair: Two cards of the same value.
# 3 Two Pairs: Two different pairs.
# 4 Three of a Kind: Three cards of the same value.
# 5 Straight: All cards are consecutive values.
# 6 Flush: All cards of the same suit.
# 7 Full House: Three of a kind and a pair.
# 8 Four of a Kind: Four cards of the same value.
# 9 Straight Flush: All cards are consecutive values of same suit.

RSpec.describe Hand, type: :model do
  describe "#score! results" do
    describe "#scored_hand_strength" do
      it "should return 9 when the Hand contains a straight flush" do
        hand = Hand.new(
          cards: 5.times.map {|i| Card.new(rank_strength: i, suit: "H")}
        )
        hand.score!

        expect(hand.scored_hand_strength).to eq(9)

        hand.cards = hand.cards.shuffle

        expect(hand.scored_hand_strength).to eq(9)
      end

      it "should return 8 when the Hand contains Four of a Kind" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 0, suit: "S"),
            Card.new(rank_strength: 0, suit: "D"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_hand_strength).to eq(8)

        hand.cards = hand.cards.shuffle

        expect(hand.scored_hand_strength).to eq(8)
      end

      it "should return 7 when the Hand is a Full House" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 0, suit: "S"),
            Card.new(rank_strength: 4, suit: "D"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_hand_strength).to eq(7)

        hand.cards = hand.cards.shuffle

        expect(hand.scored_hand_strength).to eq(7)
      end

      it "should return 6 when the Hand contains a flush without a straight" do
        hand = Hand.new(
          cards: 5.times.map {|i| Card.new(rank_strength: i*2, suit: "H")}
        )
        hand.score!

        expect(hand.scored_hand_strength).to eq(6)

        hand.cards = hand.cards.shuffle

        expect(hand.scored_hand_strength).to eq(6)
      end

      it "should return 5 when the Hand contains an unsuited straight" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 1, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
            Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_hand_strength).to eq(5)

        hand.cards = hand.cards.shuffle

        expect(hand.scored_hand_strength).to eq(5)
      end

      it "should return 4 when the Hand contains Three of a Kind" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 0, suit: "C"),
            Card.new(rank_strength: 2, suit: "H"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_hand_strength).to eq(4)

        hand.cards = hand.cards.shuffle

        expect(hand.scored_hand_strength).to eq(4)
      end

      it "should return 3 when the Hand contains Two Pairs" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
            Card.new(rank_strength: 2, suit: "H"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_hand_strength).to eq(3)

        hand.cards = hand.cards.shuffle

        expect(hand.scored_hand_strength).to eq(3)
      end

      it "should return 2 when the Hand contains One Pair" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
            Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_hand_strength).to eq(2)

        hand.cards = hand.cards.shuffle

        expect(hand.scored_hand_strength).to eq(2)
      end

      it "should return 1 when the Hand only has a High Card" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 1, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
            Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 6, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_hand_strength).to eq(1)

        hand.cards = hand.cards.shuffle

        expect(hand.scored_hand_strength).to eq(1)
      end
    end

    describe "#scored_card_strengths" do
      it "should put all cards in the scored bucket for a Straight Flush" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 1, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
            Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_card_strengths).to eq([4,3,2,1,0])

        hand.cards = hand.cards.shuffle

        expect(hand.scored_card_strengths).to eq([4,3,2,1,0])
      end

    it "should return an Array with [the value of the Four of a Kind, then the kicker]" do
      hand = Hand.new(
        cards: [
          Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 0, suit: "S"),
          Card.new(rank_strength: 0, suit: "D"), Card.new(rank_strength: 4, suit: "H")
        ]
      )
      hand.score!

      expect(hand.scored_card_strengths).to eq([0,4])

      hand.cards = hand.cards.shuffle

      expect(hand.scored_card_strengths).to eq([0,4])
    end

    it "should return an Array with [the value of the Three of a Kind, then the Pair]" do
      hand = Hand.new(
        cards: [
          Card.new(rank_strength: 1, suit: "C"), Card.new(rank_strength: 1, suit: "H"), Card.new(rank_strength: 1, suit: "S"),
          Card.new(rank_strength: 5, suit: "D"), Card.new(rank_strength: 5, suit: "H")
        ]
      )
      hand.score!

      expect(hand.scored_card_strengths).to eq([1,5])

      hand.cards = hand.cards.shuffle

      expect(hand.scored_card_strengths).to eq([1,5])
    end

      it "should put all cards in the scored bucket for a Flush" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 7, suit: "H"), Card.new(rank_strength: 1, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
            Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_card_strengths).to eq([7,4,3,2,1])

        hand.cards = hand.cards.shuffle

        expect(hand.scored_card_strengths).to eq([7,4,3,2,1])
      end

      it "should put all cards in the scored bucket for a Straight" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 1, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
            Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_card_strengths).to eq([4,3,2,1,0])

        hand.cards = hand.cards.shuffle

        expect(hand.scored_card_strengths).to eq([4,3,2,1,0])
      end

      it "should return an Array with [the value of the Three of a Kind, higher kicker, lower kicker]" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 0, suit: "C"),
            Card.new(rank_strength: 2, suit: "H"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_card_strengths).to eq([0,4,2])

        hand.cards = hand.cards.shuffle

        expect(hand.scored_card_strengths).to eq([0,4,2])
      end

      it "should return an Array with [the value of the higher Pair, lower Pair, kicker]" do
      hand = Hand.new(
        cards: [
          Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 6, suit: "H"),
          Card.new(rank_strength: 6, suit: "H"), Card.new(rank_strength: 4, suit: "H")
        ]
      )
      hand.score!

      expect(hand.scored_card_strengths).to eq([6,0,4])

      hand.cards = hand.cards.shuffle

      expect(hand.scored_card_strengths).to eq([6,0,4])
    end

    it "should return an Array with [the value of the Pair, highest kicker, middle kicker, lowest kicker]" do
      hand = Hand.new(
        cards: [
          Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
          Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 4, suit: "H")
        ]
      )
      hand.score!

      expect(hand.scored_card_strengths).to eq([0,4,3,2])

      hand.cards = hand.cards.shuffle

      expect(hand.scored_card_strengths).to eq([0,4,3,2])
    end

      it "should put all cards in the scored bucket for a High Card" do
        hand = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 1, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
            Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 6, suit: "H")
          ]
        )
        hand.score!

        expect(hand.scored_card_strengths).to eq([6,3,2,1,0])

        hand.cards = hand.cards.shuffle

        expect(hand.scored_card_strengths).to eq([6,3,2,1,0])
      end
    end
  end

  describe "<=>" do
    context "when hands differ in strength" do
      it "should compare #rank_strength against 2 differently strong Cards" do
      high_card_hand = Hand.new(
        cards: [
          Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 1, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
          Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 6, suit: "H")
        ]
      )
      high_card_hand.score!

      full_house_hand = Hand.new(
        cards: [
          Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 0, suit: "S"),
          Card.new(rank_strength: 4, suit: "D"), Card.new(rank_strength: 4, suit: "H")
        ]
      )
      full_house_hand.score!

        expect(full_house_hand).to be > high_card_hand
      end
    end

    context "when hands are the same strength" do
      it "should compare the cards played when the first kicker wins" do
        high_card_hand_winner = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 1, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
            Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 10, suit: "H")
          ]
        )
        high_card_hand_winner.score!

        high_card_hand_loser = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 1, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
            Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 6, suit: "H")
          ]
        )
        high_card_hand_loser.score!

        expect(high_card_hand_winner).to be > high_card_hand_loser
      end

      it "should compare the cards played continuing on if kickers are initially also tied" do
        high_card_hand_winner = Hand.new(
          cards: [
            Card.new(rank_strength: 5, suit: "C"), Card.new(rank_strength: 6, suit: "H"), Card.new(rank_strength: 7, suit: "H"),
            Card.new(rank_strength: 8, suit: "H"), Card.new(rank_strength: 10, suit: "H")
          ]
        )
        high_card_hand_winner.score!

        high_card_hand_loser = Hand.new(
          cards: [
            Card.new(rank_strength: 2, suit: "C"), Card.new(rank_strength: 6, suit: "H"), Card.new(rank_strength: 7, suit: "H"),
            Card.new(rank_strength: 8, suit: "H"), Card.new(rank_strength: 10, suit: "H")
          ]
        )
        high_card_hand_loser.score!

        expect(high_card_hand_winner).to be > high_card_hand_loser
      end

      it "should compare matched cards first (e.g. Pair) when calculating strength" do
        two_pair_hand_winner = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 2, suit: "D"),
            Card.new(rank_strength: 2, suit: "S"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        two_pair_hand_winner.score!

        two_pair_hand_loser = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 1, suit: "D"),
            Card.new(rank_strength: 1, suit: "S"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        two_pair_hand_loser.score!

        expect(two_pair_hand_winner).to be > two_pair_hand_loser
      end

      it "should compare MORE matched when the first are equal" do
        two_pair_hand_winner = Hand.new(
          cards: [
            Card.new(rank_strength: 3, suit: "C"), Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 2, suit: "H"),
            Card.new(rank_strength: 6, suit: "S"), Card.new(rank_strength: 6, suit: "H")
          ]
        )
        two_pair_hand_winner.score!

        two_pair_hand_loser = Hand.new(
          cards: [
            Card.new(rank_strength: 0, suit: "C"), Card.new(rank_strength: 0, suit: "H"), Card.new(rank_strength: 6, suit: "D"),
            Card.new(rank_strength: 6, suit: "S"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        two_pair_hand_loser.score!

        expect(two_pair_hand_winner).to be > two_pair_hand_loser
      end

      it "should compare kicker when all matched cards are equal" do
        two_pair_hand_winner = Hand.new(
          cards: [
            Card.new(rank_strength: 3, suit: "C"), Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 6, suit: "H"),
            Card.new(rank_strength: 6, suit: "S"), Card.new(rank_strength: 9, suit: "H")
          ]
        )
        two_pair_hand_winner.score!

        two_pair_hand_loser = Hand.new(
          cards: [
            Card.new(rank_strength: 3, suit: "C"), Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 6, suit: "D"),
            Card.new(rank_strength: 6, suit: "S"), Card.new(rank_strength: 4, suit: "H")
          ]
        )
        two_pair_hand_loser.score!

        expect(two_pair_hand_winner).to be > two_pair_hand_loser
      end

      it "should return equal is matched cards and kickers are of equal rank" do
        two_pair_hand_winner = Hand.new(
          cards: [
            Card.new(rank_strength: 3, suit: "C"), Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 6, suit: "H"),
            Card.new(rank_strength: 6, suit: "S"), Card.new(rank_strength: 9, suit: "H")
          ]
        )
        two_pair_hand_winner.score!

        two_pair_hand_loser = Hand.new(
          cards: [
            Card.new(rank_strength: 3, suit: "C"), Card.new(rank_strength: 3, suit: "H"), Card.new(rank_strength: 6, suit: "D"),
            Card.new(rank_strength: 6, suit: "S"), Card.new(rank_strength: 9, suit: "H")
          ]
        )
        two_pair_hand_loser.score!

        expect(two_pair_hand_winner).to eq(two_pair_hand_loser)
      end
    end
  end
end
