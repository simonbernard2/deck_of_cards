# typed: true
# frozen_string_literal: true

require "test_helper"
require "debug"

class PacketTest < Minitest::Test
  def setup
    @full_deck = create_full_deck
  end

  def test_a_packet_must_contain_at_least_one_card
    assert_raises ArgumentError do
      Packet.new(cards: [])
    end
  end

  def test_size_returns_the_number_of_cards_in_the_packet
    card = Card.new(suit: "H", value: "A")
    packet = Packet.new(cards: [card])

    assert_equal 1, packet.size
  end

  def test_instantiating_a_packet_gives_the_card_a_position
    card = Card.new(suit: "H", value: "A")
    packet = Packet.new(cards: [card])
    assert 1, packet.cards.first
  end

  def test_cut_cuts_a_packet_of_x_number_of_cards
    packet = @full_deck.cut(number: 26)
    assert_equal 26, packet.size
    assert_equal 26, @full_deck.size
  end

  def test_faro_two_packets_of_cards
    deck = @full_deck
    refute_equal deck.cards[0].value, deck.cards[1].value

    cut_cards = deck.cut(number: 26)
    deck.faro(other_packet: cut_cards)

    assert_equal deck.cards[0].value, deck.cards[1].value
  end

  def test_reverse_reverses_the_order_of_the_cards
    deck = @full_deck
    first_card = deck.cards.first
    deck.reverse
    last_card = deck.cards.last

    assert_equal first_card, last_card
  end

  def test_creates_the_mnemonica_stack # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    clubs = @full_deck.cards.select { |card| card.suit == "C" }
    hearts = @full_deck.cards.select { |card| card.suit == "H" }
    spades = @full_deck.cards.select { |card| card.suit == "S" }
    diamonds = @full_deck.cards.select { |card| card.suit == "D" }

    # reverse hearts and clubs
    deck = Packet.new(cards: [spades, hearts, diamonds.reverse, clubs.reverse].flatten)

    # make 4 faro shuffles
    4.times do
      top_half = deck.cut(number: 26)
      deck.faro(other_packet: top_half)
    end

    # reverse the first 26 cards
    top_half = deck.cut(number: 26)
    top_half.reverse
    deck.cards = [top_half.cards, deck.cards].flatten

    # faro the 18 first cards
    top_half = deck.cut(number: 18)
    deck.faro(other_packet: top_half)

    # cut the 9D to the bottom
    deck.cut_and_complete(number: 9)
    deck.set_cards_positions

    first_card = T.must(deck.cards.first)
    assert_equal "C", first_card.suit
    assert_equal "4", first_card.value

    last_card = T.must(deck.cards.last)
    assert_equal "D", last_card.suit
    assert_equal "9", last_card.value
  end

  def test_cutting_a_negative_amout_of_cards_raises_an_error
    assert_raises(ArgumentError) do
      @full_deck.cut(number: -10)
    end
  end

  def test_riffle_shuffle_shuffles_the_deck # rubocop:disable Metrics/AbcSize
    original_cards = @full_deck.cards.dup
    original_clubs = @full_deck.cards.select { |card| card.suit == "C" }.dup

    left_half = @full_deck.cut(number: 26)
    @full_deck.riffle_shuffle(other_packet: left_half)

    clubs = @full_deck.cards.select { |card| card.suit == "C" }

    refute_equal original_cards.map(&:to_s), @full_deck.cards.to_s
    assert_equal original_clubs.map(&:to_s), clubs.map(&:to_s)
  end

  private

  def create_full_deck
    cards = []
    Card.suits.each do |suit|
      Card.values.each do |value| # rubocop:disable Style/HashEachMethods
        cards << Card.new(suit:, value:)
      end
    end
    Packet.new(cards:)
  end
end
