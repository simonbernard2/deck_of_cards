# frozen_string_literal: true
# typed: strict

module PokerHands
  class Flush < PokerHand
    sig { override.returns(Integer) }
    def rank
      6
    end

    sig { override.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other)
      return rank <=> other.rank unless instance_of?(other.class)

      0
    end

    class << self
      sig { params(cards: T::Array[Card]).returns(T::Boolean) }
      def is?(cards)
        suit = T.must(cards.first).suit
        cards.all? { _1.suit == suit }
      end
    end
  end
end
