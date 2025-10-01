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

  class << self
    extend T::Sig

    sig { params(file_path: String).returns(Packet) }
    def build_from_text_file(file_path:) # rubocop:disable Metrics
      file_content = File.read(file_path)
      cards = []
      cards_set = Set.new

      file_content.each_line do |line|
        value, suit = line.chomp.split(":")
        raise StandardError unless value && suit

        card = Card.new(suit:, value:)
        card_string = card.to_s
        raise StandardError, "Duplicate card. (#{card_string})" if cards_set.include?(card_string)

        cards_set << card_string
        cards << card
      end

      packet = Packet.new(cards:)
      packet.set_cards_positions

      packet
    end
  end

  sig { returns(Card) }
  def deal
    raise StandardError if size.zero?

    T.must(cards.slice!(0))
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
      piles.each { |pile| pile << deal }
    end

    piles.map { Packet.new(cards: _1) }
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

  sig { params(other_packet: Packet).void }
  def riffle_shuffle(other_packet:) # rubocop:disable Metrics/AbcSize
    shuffled_cards = []
    until cards.empty? && other_packet.cards.empty?
      if !cards.empty? && (other_packet.cards.empty? || rand < 0.5)
        shuffled_cards.concat(cards.shift(rand(1..3)))
      else
        shuffled_cards.concat(other_packet.cards.shift(rand(1..3)))
      end
    end
    self.cards = shuffled_cards
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
