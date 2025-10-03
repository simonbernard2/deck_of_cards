# typed: strict
# frozen_string_literal: true

# This represents a packet of cards
class Packet
  extend T::Sig
  require "deck_of_cards/packet/shuffles"
  require "deck_of_cards/packet/deals"
  require "deck_of_cards/packet/cuts"
  include Deals
  include Cuts

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
      set_cards_positions(packet:)

      packet
    end

    private

    sig { params(packet: Packet).void }
    def set_cards_positions(packet:)
      packet.cards.each_with_index do |card, index|
        card.position = index + 1
      end
    end
  end

  sig { params(other_packet: Packet).void }
  def faro(other_packet:)
    self.cards = Shuffles.faro_shuffle(top_half: self, bottom_half: other_packet)
  end

  sig { params(other_packet: Packet).void }
  def riffle_shuffle(other_packet:)
    self.cards = Shuffles.riffle_shuffle(left_half: self, right_half: other_packet)
  end

  sig { void }
  def shuffle
    self.cards = cards.shuffle
  end

  sig { void }
  def reverse
    self.cards = cards.reverse
  end

  sig { returns(T::Array[String]) }
  def to_s
    cards.map(&:to_s)
  end
end
