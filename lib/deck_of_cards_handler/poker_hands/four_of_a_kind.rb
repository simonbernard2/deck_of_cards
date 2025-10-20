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

    sig { returns(T::Array[Card]) }
    attr_reader :four_of_a_kind

    sig { returns(T::Array[Card]) }
    attr_reader :kicker

    sig { params(cards: T::Array[Card]).void }
    def initialize(cards:)
      super
      @four_of_a_kind = T.let(extract_four_of_a_kind, T::Array[Card])
      @kicker = T.let(extract_kicker, T::Array[Card])
    end

    sig { override.returns(Integer) }
    def rank
      8
    end

    sig { override.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other)
      return rank <=> other.rank unless instance_of?(other.class)

      comparison = four_of_a_kind_value <=> other.four_of_a_kind_value
      return comparison unless comparison.zero?

      kicker_value <=> other.kicker_value
    end

    protected

    sig { returns(Integer) }
    def four_of_a_kind_value
      T.must(four_of_a_kind.first).rank
    end

    sig { returns(Integer) }
    def kicker_value
      T.must(kicker.first).rank
    end

    private

    sig { returns(T::Array[Card]) }
    def extract_four_of_a_kind
      cards.group_by(&:rank).values.select { _1.size == 4 }.flatten
    end

    sig { returns(T::Array[Card]) }
    def extract_kicker
      cards.group_by(&:rank).values.select { _1.size == 1 }.flatten
    end
  end
end
