# frozen_string_literal: true
# typed: true

# Includes dealing methods, that either returns a single Card or Packet(s) of cards
module Deals
  extend T::Helpers
  extend T::Sig

  requires_ancestor { Packet }
  sig { returns(Card) }
  def top_deal
    raise StandardError if size.zero?

    T.must(cards.slice!(0))
  end

  sig { returns(Card) }
  def second_deal
    raise StandardError if size < 2

    T.must(cards.slice!(1))
  end

  sig { returns(Card) }
  def bottom_deal
    raise StandardError if size.zero?

    T.must(cards.pop)
  end

  sig { params(number_of_piles: Integer, number_of_cards: Integer).returns(T::Array[Packet]) }
  def deal_into_piles(number_of_piles:, number_of_cards:)
    raise StandardError, "Not enough cards" if (number_of_cards * number_of_piles) > size
    raise StandardError, "Invalid number_of_cards" unless number_of_cards.positive?

    piles = Array.new(number_of_piles) { [] }
    number_of_cards.times do
      piles.each { |pile| pile << top_deal }
    end

    piles.map { Packet.new(cards: _1) }
  end
end
