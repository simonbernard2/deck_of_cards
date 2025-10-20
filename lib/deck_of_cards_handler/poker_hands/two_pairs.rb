# frozen_string_literal: true
# typed: strict

module PokerHands
  class TwoPairs < PokerHand
    sig { returns(T::Array[Card]) }
    attr_reader :pairs

    sig { returns(T::Array[Card]) }
    attr_reader :kicker

    sig { params(cards: T::Array[Card]).void }
    def initialize(cards:)
      super
      @pairs = T.let(extract_pairs, T::Array[Card])
      @kicker = T.let(extract_kicker, T::Array[Card])
    end

    sig { override.returns(Integer) }
    def rank
      3
    end

    sig { override.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other) # rubocop:disable Metrics/AbcSize
      return rank <=> other.rank unless instance_of?(other.class)

      first_pair_comparison = pair_values.first <=> other.pair_values.first
      return first_pair_comparison unless T.must(first_pair_comparison).zero?

      second_pair_comparison = pair_values.last <=> other.pair_values.last
      return second_pair_comparison unless T.must(second_pair_comparison).zero?

      kickers_value <=> other.kickers_value
    end

    class << self
      sig { params(cards: T::Array[Card]).returns(T::Boolean) }
      def is?(cards)
        counts = cards.map(&:rank).flatten.tally
        counts.values.count(2) == 2
      end
    end

    protected

    sig { returns(T::Array[Integer]) }
    def pair_values
      pairs.map(&:rank).sort.reverse
    end

    sig { returns(Integer) }
    def kickers_value
      T.must(kicker.map(&:rank).reduce(&:+))
    end

    private

    sig { returns(T::Array[Card]) }
    def extract_pairs
      cards.group_by(&:rank).values.select { _1.size == 2 }.flatten
    end

    sig { returns(T::Array[Card]) }
    def extract_kicker
      cards.group_by(&:rank).values.select { _1.size == 1 }.flatten
    end
  end
end
