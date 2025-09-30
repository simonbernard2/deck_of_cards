# typed: strict
# frozen_string_literal: true

# This represents a packet of cards
class Packet
  extend T::Sig

  sig { returns(T::Array[Card]) }
  attr_accessor :cards

  sig { params(cards: T::Array[Card]).void }
  def initialize(cards:)
    raise ArgumentError if cards.empty?

    @cards = T.let(cards, T::Array[Card])
  end

  sig { returns(Integer) }
  def size
    cards.size
  end

  sig { params(number: Integer).returns(Packet) }
  def cut(number:)
    raise ArgumentError if invalid_number_to_cut_to?(number)
    return self if number >= size

    cut_cards = cards.slice!(0...number)
    Packet.new(cards: T.must(cut_cards))
  end

  sig { params(number: Integer).void }
  def cut_and_complete(number:)
    top_half = cut(number:)
    self.cards = [cards, top_half.cards].flatten
  end

  sig { params(number: Integer).returns(Packet) }
  def cut_and_complete!(number:)
    cut_and_complete(number:)
    self
  end

  sig { params(other_packet: Packet).void }
  def faro(other_packet:)
    first_half = other_packet.cards
    second_half = cards
    remaining_cards = []

    remaining_cards = second_half[first_half.size..second_half.size] if first_half.size < second_half.size

    zipped_cards = first_half.zip(second_half).flatten.compact
    self.cards = [zipped_cards, remaining_cards].flatten.compact
  end

  sig { returns(Packet) }
  def shuffle
    self.cards = cards.shuffle
    self
  end

  sig { returns(Packet) }
  def reverse
    self.cards = cards.reverse
    self
  end

  sig { returns(T::Array[String]) }
  def to_s
    cards.map(&:to_s)
  end

  sig { void }
  def set_cards_positions
    cards.each_with_index do |card, index|
      card.position = index + 1
    end
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
