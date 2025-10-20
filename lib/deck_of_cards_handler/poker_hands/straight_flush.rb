# frozen_string_literal: true
# typed: strict

module PokerHands
  class StraightFlush < PokerHand
    sig { override.returns(Integer) }
    def rank
      9
    end

    sig { override.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other)
      return rank <=> other.rank unless instance_of?(other.class)

      c1 = cards.map { card_value(_1) }
      c2 = other.cards.map { other.card_value(_1) }

      c1 <=> c2
    end

    class << self
      sig { params(cards: T::Array[Card]).returns(T::Boolean) }
      def is?(cards)
        Flush.is?(cards) && Straight.is?(cards)
      end
    end

    protected

    sig { params(card: Card).returns(Integer) }
    def card_value(card)
      return card.rank unless card.value == "A"
      return 1 if low_ace?

      14
    end

    private

    sig { returns(T::Boolean) }
    def low_ace?
      ranks = cards.map { _1.rank(low_ace: true) }.sort
      ranks.each_cons(2).all? { |a, b| b == T.must(a) + 1 }
    end
  end
end
