# typed: strict
# frozen_string_literal: true

module PokerHands
  # This represents a poker hands raking
  class PokerHand
    extend T::Sig
    extend T::Helpers
    include Comparable
    abstract!

    sig { returns(T::Array[Card]) }
    attr_reader :cards

    sig { params(cards: T::Array[Card]).void }
    def initialize(cards:)
      raise ArgumentError if cards.size != 5

      @cards = cards
    end

    HANDS = %i[OnePair TwoPairs ThreeOfAKind Straight Flush FullHouse FourOfAKind StraightFlush].freeze

    sig { abstract.params(other: T.untyped).returns(T.nilable(Integer)) }
    def <=>(other); end

    sig { abstract.returns(Integer) }
    def rank; end

    class << self
      extend T::Sig
      sig { params(string: String).returns(PokerHand) }
      def build_from_string(string:)
        cards = Packet.build_from_string(string:).cards
        PokerHand.create(cards:)
      end

      sig do
        params(cards: T::Array[Card]).returns(
          T.any(
            HighCard,
            OnePair,
            TwoPairs,
            ThreeOfAKind,
            Straight,
            Flush,
            FullHouse,
            FourOfAKind,
            StraightFlush
          )
        )
      end
      def create(cards:)
        HANDS.reverse_each do |hand|
          return PokerHands.const_get(hand).new(cards:) if PokerHands.const_get(hand).is?(cards)
        end
        HighCard.new(cards:)
      end
    end
  end
end
