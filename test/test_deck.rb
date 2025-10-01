# typed: true
# frozen_string_literal: true

require "test_helper"
require "debug"

class DeckTest < Minitest::Test
  def test_build_from_text_file
    file_path = "data/mnemonica.txt"
    deck = Deck.build_from_text_file(file_path:, name: "Mnemonica")

    assert_equal 52, deck.size
    assert_equal "Mnemonica", deck.name
    assert_equal "4 of C", deck.cards.first.to_s
    assert_equal "9 of D", deck.cards.last.to_s
  end

  def test_build_sets_a_position_to_the_cards
    file_path = "data/mnemonica.txt"
    deck = Deck.build_from_text_file(file_path:, name: "Mnemonica")

    assert_equal (1..52).to_a, deck.cards.map(&:position)
  end

  def test_build_from_text_file_raise_error_on_duplicate_cards
    file_path = "data/duplicate_cards.txt"
    error = assert_raises do
      Deck.build_from_text_file(file_path:, name: "invalid")
    end

    assert_equal "Duplicate card. (10 of H)", error.message
  end
end
