# frozen_string_literal: true
# typed: strict

module PokerHands
  class Straight < PokerHand
    # sig { returns(T::Array[Card]) }
    # attr_reader :pair

    sig { params(cards: T::Array[Card]).void }
    def initialize(cards:)
      super
    end

    sig { override.returns(Integer) }
    def rank
      5
    end

    sig { override.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other)
      rank <=> other.rank
    end

    class << self
      sig { params(cards: T::Array[Card]).returns(T::Boolean) }
      def is?(cards)
        ranks = cards.map(&:rank).sort
        return true if ranks.each_cons(2).all? { |a, b| b == T.must(a) + 1 }

        ranks = cards.map { _1.rank(low_ace: true) }
        ranks.each_cons(2).all? { |a, b| b == T.must(a) + 1 }
      end
    end
  end
end
