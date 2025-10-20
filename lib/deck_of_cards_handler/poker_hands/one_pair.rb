# frozen_string_literal: true
# typed: strict

module PokerHands
  class OnePair < PokerHand
    sig { returns(T::Array[Card]) }
    attr_reader :pair

    sig { returns(T::Array[Card]) }
    attr_reader :kickers

    sig { params(cards: T::Array[Card]).void }
    def initialize(cards:)
      super
      @pair = T.let(extract_pair, T::Array[Card])
      @kickers = T.let(extract_kickers, T::Array[Card])
    end

    sig { override.returns(Integer) }
    def rank
      2
    end

    sig { override.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other)
      return rank <=> other.rank unless instance_of?(other.class)

      pair_comparison = pair_value <=> other.pair_value
      return pair_comparison unless pair_comparison.zero?

      kickers_value <=> other.kickers_value
    end

    class << self
      sig { params(cards: T::Array[Card]).returns(T::Boolean) }
      def is?(cards)
        counts = cards.map(&:rank).flatten.tally
        counts.values.count(2) == 1
      end
    end

    protected

    sig { returns(Integer) }
    def pair_value
      T.must(pair.first).rank
    end

    sig { returns(Integer) }
    def kickers_value
      T.must(kickers.map(&:rank).reduce(&:+))
    end

    private

    sig { returns(T::Array[Card]) }
    def extract_pair
      cards.group_by(&:rank).values.select { _1.size == 2 }.flatten
    end

    sig { returns(T::Array[Card]) }
    def extract_kickers
      cards.group_by(&:rank).values.select { _1.size == 1 }.flatten
    end
  end
end
