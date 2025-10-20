# frozen_string_literal: true
# typed: strict

module Shuffles
  class << self
    extend T::Sig
    sig { params(left_half: Packet, right_half: Packet).returns(T::Array[Card]) }
    def riffle_shuffle(left_half:, right_half:)
      shuffled_cards = []
      until left_half.cards.empty? && right_half.cards.empty?
        if !left_half.cards.empty? && (right_half.cards.empty? || Kernel.rand < 0.5)
          shuffled_cards.concat(left_half.cards.shift(Kernel.rand(1..3)))
        else
          shuffled_cards.concat(right_half.cards.shift(Kernel.rand(1..3)))
        end
      end
      shuffled_cards
    end

    sig { params(top_half: Packet, bottom_half: Packet).returns(T::Array[Card]) }
    def faro_shuffle(top_half:, bottom_half:)
      top_cards = top_half.cards
      bottom_cards = bottom_half.cards
      remaining_cards = []

      remaining_cards = top_cards[bottom_cards.size..top_cards.size] if bottom_cards.size < top_cards.size

      zipped_cards = bottom_cards.zip(top_cards).flatten.compact
      [zipped_cards, remaining_cards].flatten.compact
    end
  end
end
