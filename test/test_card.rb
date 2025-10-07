# typed: true
# frozen_string_literal: true

require "test_helper"

class TestCard < Minitest::Test
  def test_instantiating_a_card_requires_a_valid_suit
    error = assert_raises(ArgumentError) do
      Card.new(suit: "X", value: "10")
    end

    assert_equal "Invalid suit", error.message
  end

  def test_instantiating_a_card_requires_a_valid_value
    error = assert_raises(ArgumentError) do
      Card.new(suit: "H", value: "19")
    end

    assert_equal "Invalid value", error.message
  end

  def test_color_gives_the_card_color
    black_card = Card.new(suit: "S", value: "A")
    red_card = Card.new(suit: "H", value: "A")

    assert "black", black_card.color
    assert "red", red_card.color
  end

  def test_suits
    assert_equal %w[C H S D], Card.suits
  end

  def test_values
    assert_equal %w[A 2 3 4 5 6 7 8 9 10 J Q K], Card.values
  end

  def test_equality
    first_card = Card.new(suit: "H", value: "10")
    second_card = Card.new(suit: "H", value: "10")

    assert_equal first_card, second_card
  end

  def test_comparison
    unsorted_values = %w[K A 9 10 Q J]
    cards = unsorted_values.map { Card.new(suit: "H", value: _1) }

    expected = %w[9 10 J Q K A]
    assert_equal expected, cards.sort.map(&:value)
  end
end
