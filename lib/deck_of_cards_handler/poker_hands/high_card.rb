# frozen_string_literal: true
# typed: strict

module PokerHands
  class HighCard < PokerHand
    sig { override.returns(Integer) }
    def rank
      1
    end

    sig { override.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other)
      return rank <=> other.rank if self.class != other.class

      sum_cards_ranks(cards) <=> sum_cards_ranks(other.cards)
    end

    private

    sig { params(cards: T::Array[Card]).returns(Integer) }
    def sum_cards_ranks(cards)
      T.must(cards.map(&:rank).reduce(&:+))
    end
  end
end
