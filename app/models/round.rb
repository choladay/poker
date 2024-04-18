class Round
    include ActiveModel::AttributeMethods

    attr_accessor :full_deck, :hands

    def initialize
        @full_deck = %w(C D H S).map do |suit|
            %w(2 3 4 5 6 7 8 9 T J Q K A).map.with_index do |rank, i|
                Card.new(
                    rank: rank,
                    rank_strength: i,
                    suit: suit
                )
            end
        end.flatten
        @hands = []
    end

    def parse_hand!(card_array, player)
        hand = Hand.new
        card_array.map do |card_string|
            hand.cards << full_deck.find do |deck_card|
                deck_card.rank == card_string[0] && deck_card.suit == card_string[1]
            end
        end
        hand.player = player
        hand.score!

        self.hands << hand
        hand
    end

    def winning_hand
        hands.sort.reverse.first
    end

    def print_round_results
        puts "ROUND RESULTS\n------------------------"

        hands.sort.reverse.each_with_index do |hand, i|
            puts "#{(i+1).ordinalize}) #{hand} with #{hand.hand_strength_humanized}"
        end
    end
end
