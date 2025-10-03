# frozen_string_literal: true
# typed: true

# Includes cutting methods, either splits or assembles packets of cards
module Cuts
  extend T::Helpers
  extend T::Sig
  requires_ancestor { Packet }

  sig { params(number: Integer).returns(Packet) }
  def cut(number:)
    raise ArgumentError if invalid_number_to_cut_to?(number)

    cut_cards = cards.slice!(0...number)
    Packet.new(cards: T.must(cut_cards))
  end

  sig { params(number: Integer).void }
  def cut_and_complete(number:)
    top_half = cut(number:)
    self.cards = [cards, top_half.cards].flatten
  end

  private

  sig { params(number: Integer).returns(T::Boolean) }
  def invalid_number_to_cut_to?(number)
    return true if number.negative?
    return true if number.zero?
    return true if number >= cards.size

    false
  end
end
