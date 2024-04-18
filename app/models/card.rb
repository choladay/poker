class Card
    include ActiveModel::AttributeMethods
    include Comparable

    attr_accessor :rank, :rank_strength, :suit

    def initialize(options = {})
        @rank = options[:rank]
        @rank_strength = options[:rank_strength]
        @suit = options[:suit]
    end

    def <=>(other)
        rank_strength <=> other.rank_strength
    end

    def to_s
        "#{rank}#{suit}"
    end

    def inspect
        {suit: suit, rank: rank, rank_strength: rank_strength}
    end
end