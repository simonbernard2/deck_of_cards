# frozen_string_literal: true
# typed: strict

module PokerHands
  class StraightFlush < PokerHand
    sig { params(cards: T::Array[Card]).void }
    def initialize(cards:)
      super
    end

    sig { override.returns(Integer) }
    def rank
      9
    end

    sig { override.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other)
      rank <=> other.rank
    end

    class << self
      sig { params(cards: T::Array[Card]).returns(T::Boolean) }
      def is?(cards)
        Flush.is?(cards) && Straight.is?(cards)
      end
    end
  end
end
