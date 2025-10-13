# typed: strict
# frozen_string_literal: true

# This represents a poker hands raking
class PokerHand < Packet
  extend T::Sig
  extend T::Helpers

  sig { params(cards: T::Array[Card]).void }
  def initialize(cards:)
    raise ArgumentError if cards.size != 5

    super
  end

  class << self
    sig { override.params(string: String).returns(PokerHand) }
    def build_from_string(string:)
      result = super
      PokerHand.new(cards: result.cards)
    end
  end

  HAND_RANKS = T.let(
    {
      nothing: 0,
      pair: 1,
      two_pairs: 2,
      three_of_a_kind: 3,
      straight: 4,
      flush: 5,
      full_house: 6,
      four_of_a_kind: 7,
      straight_flush: 8
    }.freeze, T::Hash[Symbol, Integer]
  )

  sig { returns(Integer) }
  def rank # rubocop:disable Metrics
    return T.must(HAND_RANKS[:straight_flush]) if straight_flush?
    return T.must(HAND_RANKS[:four_of_a_kind]) if four_of_a_kind?
    return T.must(HAND_RANKS[:full_house]) if full_house?
    return T.must(HAND_RANKS[:flush]) if flush?
    return T.must(HAND_RANKS[:straight]) if straight?
    return T.must(HAND_RANKS[:three_of_a_kind]) if three_of_a_kind?
    return T.must(HAND_RANKS[:two_pairs]) if two_pairs?
    return T.must(HAND_RANKS[:pair]) if pair?

    T.must(HAND_RANKS[:nothing])
  end

  sig { returns(T::Boolean) }
  def pair?
    validate_hand_size

    counts = cards.map(&:rank).flatten.tally
    counts.values.count(2) == 1
  end

  sig { returns(T::Boolean) }
  def two_pairs?
    validate_hand_size

    counts = cards.map(&:rank).flatten.tally
    counts.values.count(2) == 2
  end

  sig { returns(T::Boolean) }
  def three_of_a_kind?
    validate_hand_size

    counts = cards.map(&:rank).flatten.tally
    counts.values.count(3) == 1
  end

  sig { returns(T::Boolean) }
  def straight? # rubocop:disable Metrics/AbcSize
    validate_hand_size

    ranks = cards.map(&:rank).sort
    return true if ranks.each_cons(2).all? { |a, b| b == T.must(a) + 1 }

    ranks = cards.map { _1.rank(low_ace: true) }
    ranks.each_cons(2).all? { |a, b| b == T.must(a) + 1 }
  end

  sig { returns(T::Boolean) }
  def flush?
    validate_hand_size

    suit = T.must(cards.first).suit
    cards.all? { _1.suit == suit }
  end

  sig { returns(T::Boolean) }
  def full_house?
    validate_hand_size

    three_of_a_kind? && pair?
  end

  sig { returns(T::Boolean) }
  def four_of_a_kind?
    validate_hand_size

    counts = cards.map(&:rank).flatten.tally
    counts.values.count(4) == 1
  end

  sig { returns(T::Boolean) }
  def straight_flush?
    validate_hand_size

    straight? && flush?
  end

  private

  sig { void }
  def validate_hand_size
    raise StandardError unless size == 5
  end
end
