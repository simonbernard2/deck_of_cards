# typed: strict
# frozen_string_literal: true

# This represents a deck of cards
# It has a name and consist of one packet, with their cards having a position
class Deck < Packet
  extend T::Sig

  sig { returns(String) }
  attr_reader :name

  sig { params(name: String, cards: T::Array[Card]).void }
  def initialize(name:, cards:)
    super(cards:)
    @name = name
    set_cards_positions
  end

  class << self
    extend T::Sig

    sig { params(file_path: String, name: String).returns(Deck) }
    def build_from_text_file(file_path:, name:) # rubocop:disable Metrics
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

      Deck.new(cards:, name:)
    end
  end

  private

  sig { void }
  def set_cards_positions
    cards.each_with_index do |card, index|
      card.position = index + 1
    end
  end
end
