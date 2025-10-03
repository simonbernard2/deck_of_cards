# typed: true
# frozen_string_literal: true

require "test_helper"
require "debug"

class PacketTest < Minitest::Test # rubocop:disable Metrics/ClassLength
  extend T::Sig

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
    deck = create_full_deck
    packet = deck.cut(number: 26)
    assert_equal 26, packet.size
    assert_equal 26, deck.size
  end

  def test_faro_two_packets_of_cards # rubocop:disable Metrics/AbcSize
    deck = create_full_deck

    first_card = T.must(deck.cards[0])
    second_card = T.must(deck.cards[1])
    refute_equal first_card.value, second_card.value

    cut_cards = deck.cut(number: 26)
    deck.faro(other_packet: cut_cards)

    first_card = T.must(deck.cards[0])
    second_card = T.must(deck.cards[1])
    assert_equal first_card.value, second_card.value
  end

  def test_reverse_reverses_the_order_of_the_cards
    deck = create_full_deck
    first_card = deck.cards.first
    deck.reverse
    last_card = deck.cards.last

    assert_equal first_card, last_card
  end

  def test_manually_create_the_mnemonica_stack # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    clubs = create_full_deck.cards.select { |card| card.suit == "C" }
    hearts = create_full_deck.cards.select { |card| card.suit == "H" }
    spades = create_full_deck.cards.select { |card| card.suit == "S" }
    diamonds = create_full_deck.cards.select { |card| card.suit == "D" }

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

    first_card = T.must(deck.cards.first)
    assert_equal "C", first_card.suit
    assert_equal "4", first_card.value

    last_card = T.must(deck.cards.last)
    assert_equal "D", last_card.suit
    assert_equal "9", last_card.value
  end

  def test_cutting_a_negative_amout_of_cards_raises_an_error
    assert_raises(ArgumentError) do
      create_full_deck.cut(number: -10)
    end
  end

  def test_riffle_shuffle_shuffles_the_deck # rubocop:disable Metrics/AbcSize
    original_cards = create_full_deck.cards.dup
    original_clubs = create_full_deck.cards.select { |card| card.suit == "C" }.dup

    left_half = create_full_deck.cut(number: 26)
    create_full_deck.riffle_shuffle(other_packet: left_half)

    clubs = create_full_deck.cards.select { |card| card.suit == "C" }

    refute_equal original_cards.map(&:to_s), create_full_deck.cards.to_s
    assert_equal original_clubs.map(&:to_s), clubs.map(&:to_s)
  end

  def test_build_from_text_file
    file_path = "data/mnemonica.txt"
    packet = Packet.build_from_text_file(file_path:)

    assert_equal 52, packet.size
    assert_equal "4 of C", packet.cards.first.to_s
    assert_equal "9 of D", packet.cards.last.to_s
  end

  def test_build_from_text_file_assigns_positions_to_cards
    file_path = "data/mnemonica.txt"
    packet = Packet.build_from_text_file(file_path:)

    assert_equal (1..52).to_a, packet.cards.map(&:position)
  end

  def test_build_from_text_file_raise_error_on_duplicate_cards
    file_path = "data/duplicate_cards.txt"
    error = assert_raises do
      Packet.build_from_text_file(file_path:)
    end

    assert_equal "Duplicate card. (10 of H)", error.message
  end

  def test_top_deal_deals_the_top_card
    deck = create_full_deck
    card = deck.top_deal

    assert_equal "A of C", card.to_s
    assert_equal 51, deck.size
  end

  def test_bottom_deal_deals_the_bottom_card
    deck = create_full_deck
    card = deck.bottom_deal

    assert_equal "K of D", card.to_s
    assert_equal 51, deck.size
  end

  def test_deal_into_piles_deals_into_x_number_of_piles
    deck = create_full_deck
    piles = deck.deal_into_piles(number_of_piles: 4, number_of_cards: 5)

    assert_equal 4, piles.size
    assert(piles.all? { _1.size == 5 })
    assert_equal 32, deck.size
  end

  def test_deal_into_piles_deals_into_x_number_of_piles_raises_on_invalid_numbers
    assert_raises do
      create_full_deck.deal_into_piles(number_of_piles: 4, number_of_cards: -5)
    end

    assert_raises do
      create_full_deck.deal_into_piles(number_of_piles: -4, number_of_cards: 5)
    end
  end

  private

  sig { returns(Packet) }
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
