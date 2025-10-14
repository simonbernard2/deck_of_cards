# frozen_string_literal: true
# typed: strict

module PokerHands
  class HighCard < PokerHand
    # sig { returns(T::Array[Card]) }
    # attr_reader :pair

    sig { returns(Integer) }
    attr_reader :rank

    sig { params(cards: T::Array[Card]).void }
    def initialize(cards:)
      super
      @rank = T.let(1, Integer)
    end
  end
end
