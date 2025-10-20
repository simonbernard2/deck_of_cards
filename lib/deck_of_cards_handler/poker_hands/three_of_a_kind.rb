# frozen_string_literal: true
# typed: strict

module PokerHands
  class ThreeOfAKind < PokerHand
    sig { returns(T::Array[Card]) }
    attr_reader :three_of_a_kind

    sig { returns(T::Array[Card]) }
    attr_reader :kickers

    sig { params(cards: T::Array[Card]).void }
    def initialize(cards:)
      super
      @three_of_a_kind = T.let(extract_three_of_a_kind, T::Array[Card])
      @kickers = T.let(extract_kickers, T::Array[Card])
    end

    sig { override.returns(Integer) }
    def rank
      4
    end

    sig { override.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other)
      return rank <=> other.rank unless instance_of?(other.class)

      comparison = three_of_a_kind_value <=> other.three_of_a_kind_value
      return comparison unless comparison.zero?

      kickers_value <=> other.kickers_value
    end

    class << self
      sig { params(cards: T::Array[Card]).returns(T::Boolean) }
      def is?(cards)
        counts = cards.map(&:rank).flatten.tally
        counts.values.count(3) == 1
      end
    end

    protected

    sig { returns(Integer) }
    def three_of_a_kind_value
      T.must(three_of_a_kind.first).rank
    end

    sig { returns(Integer) }
    def kickers_value
      T.must(kickers.map(&:rank).reduce(&:+))
    end

    private

    sig { returns(T::Array[Card]) }
    def extract_three_of_a_kind
      cards.group_by(&:rank).values.select { _1.size == 3 }.flatten
    end

    sig { returns(T::Array[Card]) }
    def extract_kickers
      cards.group_by(&:rank).values.select { _1.size == 1 }.flatten
    end
  end
end
