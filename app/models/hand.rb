class Hand
    include ActiveModel::AttributeMethods
    include Comparable

    attr_accessor :cards, :scored_hand_strength, :scored_card_strengths, :player

    def initialize(options = {})
        @cards = options && options[:cards] || []
        @scored_hand_strength = nil
        @scored_card_strengths = []
    end

    # Sets values for comparison and sorting hands
    # scored_hand_strength: Numerical representation of hand strength, lower is weaker.
    # scored_card_strengths: The order of tiebreaking card strengths,
    #   ordered by score priority: four-of-a-kind, three-of-a-kind, pair, kicker.
    def score!
        # If the hand is a Flush
        self.scored_hand_strength = if cards.map(&:suit).uniq.one?
            # Return for straight flush, or flush if not a straight
            score_all_card_strengths!
            is_straight? ? 9 : 6
        elsif is_straight?
            # Return for unsuited straight
            score_all_card_strengths!
            5
        elsif cards.map(&:rank_strength).uniq.length == 5
            # High card
            score_all_card_strengths!
            1
        else
            # At least 2 cards match rank

            # grouped_cards will be an Array of Arrays with 2 values, the rank_strangth and the cards of that strength,
            # ordered by scoring priority then card strength
            grouped_cards = cards.group_by(&:rank_strength).sort_by {|rank_strength, cards| [cards.length * -1, rank_strength * -1]}

            self.scored_card_strengths = grouped_cards.map(&:first)

            if grouped_cards[0].last.length == 4
                # Four of a Kind
                8
            elsif grouped_cards[0].last.length == 3
                if grouped_cards[1].last.length == 2
                    # Full House
                    7
                else
                    # Three of a Kind
                    4
                end
            else
                if grouped_cards[1].last.length == 2
                    # Two Pairs
                    3
                else
                    # One Pair
                    2
                end
            end
        end
    end

    def <=>(other)
        if scored_hand_strength == other.scored_hand_strength
            # Compare each tiebreaker card
            tiebreakers = scored_card_strengths.map.with_index do |card_strength, i|
                card_strength <=> other.scored_card_strengths[i]
            end

            # Remove equivalents
            tiebreakers.reject! { |t| t.zero? }

            # If there are any values left, one hand is better and return the comparitor value for that
            # otherwise it is a tie and return 0
            tiebreakers.present? ? tiebreakers.first : 0
        else
            scored_hand_strength <=> other.scored_hand_strength
        end
    end

    def to_s
        cards.sort.reverse.map(&:to_s).join(' ')
    end

    def hand_strength_humanized

        if scored_hand_strength == 9
            if cards.sort.last.rank == "A"
                "Royal Flush"
            else
                "Straight Flush"
            end
        else
            _humanized_hands = {
                "1": "High Card",
                "2": "One Pair",
                "3": "Two Pairs",
                "4": "Three of a Kind",
                "5": "Straight",
                "6": "Flush",
                "7": "Full House",
                "8": "Four of a Kind",
            }[scored_hand_strength.to_s.to_sym]
        end
    end

    def inspect
        {cards: cards}
    end

private

    def is_straight?
        cards.sort.each_cons(2).all? {|card1, card2| (card1.rank_strength + 1) == card2.rank_strength}
    end

    # All cards are valued equally for tiebreakers
    def score_all_card_strengths!
        self.scored_card_strengths = cards.map(&:rank_strength).sort.reverse
    end
end
