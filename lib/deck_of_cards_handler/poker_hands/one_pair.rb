# frozen_string_literal: true
# typed: strict

module PokerHands
  class OnePair < PokerHand
    # sig { returns(T::Array[Card]) }
    # attr_reader :pair

    sig { returns(Integer) }
    attr_reader :rank

    sig { params(cards: T::Array[Card]).void }
    def initialize(cards:)
      super
      @rank = T.let(2, Integer)
    end

    sig { params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other)
      super
    end

    class << self
      sig { params(cards: T::Array[Card]).returns(T::Boolean) }
      def is?(cards)
        counts = cards.map(&:rank).flatten.tally
        counts.values.count(2) == 1
      end
    end
  end
end
