# frozen_string_literal: true
# typed: strict

module PokerHands
  class FullHouse < PokerHand
    class << self
      sig { params(cards: T::Array[Card]).returns(T::Boolean) }
      def is?(cards)
        PokerHands::ThreeOfAKind.is?(cards) && PokerHands::OnePair.is?(cards)
      end
    end

    sig { returns(T::Array[Card]) }
    attr_reader :three_of_a_kind

    sig { returns(T::Array[Card]) }
    attr_reader :pair

    sig { params(cards: T::Array[Card]).void }
    def initialize(cards:)
      super
      @three_of_a_kind = T.let(extract_three_of_a_kind, T::Array[Card])
      @pair = T.let(extract_pair, T::Array[Card])
    end

    sig { override.returns(Integer) }
    def rank
      7
    end

    sig { override.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other)
      return rank <=> other.rank unless instance_of?(other.class)

      comparison = three_of_a_kind_value <=> other.three_of_a_kind_value
      return comparison unless comparison.zero?

      pair_value <=> other.pair_value
    end

    protected

    sig { returns(Integer) }
    def three_of_a_kind_value
      T.must(three_of_a_kind.first).rank
    end

    sig { returns(Integer) }
    def pair_value
      T.must(pair.first).rank
    end

    private

    sig { returns(T::Array[Card]) }
    def extract_three_of_a_kind
      cards.group_by(&:rank).values.select { _1.size == 3 }.flatten
    end

    sig { returns(T::Array[Card]) }
    def extract_pair
      cards.group_by(&:rank).values.select { _1.size == 2 }.flatten
    end
  end
end
