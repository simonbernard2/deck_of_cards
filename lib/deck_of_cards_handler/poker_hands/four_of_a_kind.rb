# frozen_string_literal: true
# typed: strict

module PokerHands
  class FourOfAKind < PokerHand
    class << self
      sig { params(cards: T::Array[Card]).returns(T::Boolean) }
      def is?(cards)
        counts = cards.map(&:rank).flatten.tally
        counts.values.count(4) == 1
      end
    end

    sig { params(cards: T::Array[Card]).void }
    def initialize(cards:)
      super
    end

    sig { override.returns(Integer) }
    def rank
      8
    end

    sig { override.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other)
      rank <=> other.rank
    end
  end
end
