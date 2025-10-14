# typed: true
# frozen_string_literal: true

require "test_helper"
require "debug"

class PokerHandTest < Minitest::Test
  include PokerHands

  def test_assert_hands_has_a_pair
    string = "2:H, 3:S, K:D, 5:H, 9:S"
    hand = PokerHand.build_from_string(string:)
    refute hand.pair?

    string = "2:H, 2:S, K:D, 5:H, 9:S"
    hand = PokerHand.build_from_string(string:)
    assert hand.pair?
  end

  def test_assert_hands_has_two_pairs
    string = "2:H, 3:S, K:D, K:H, 9:S"
    hand = PokerHand.build_from_string(string:)
    refute hand.two_pairs?

    string = "2:H, 2:S, K:D, K:H, 9:S"
    hand = PokerHand.build_from_string(string:)
    assert hand.two_pairs?
  end

  def test_assert_hands_is_flush
    string = "2:S, 3:H, 8:H, 9:H, A:H"
    hand = PokerHand.build_from_string(string:)
    refute hand.flush?

    string = "2:H, 3:H, 8:H, 9:H, A:H"
    hand = PokerHand.build_from_string(string:)
    assert hand.flush?
  end

  def test_assert_hands_is_a_straight
    string = "J:S, 3:H, 4:H, 5:H, 6:H"
    hand = PokerHand.build_from_string(string:)
    refute hand.straight?

    string = "A:S, 2:H, 3:H, 4:H, 5:H"
    hand = PokerHand.build_from_string(string:)
    assert hand.straight?

    string = "10:S, J:H, Q:H, K:H, A:H"
    hand = PokerHand.build_from_string(string:)
    assert hand.straight?
  end

  def test_assert_hand_is_full_house
    string = "2:S, 2:H, 2:D, 3:H, 3:S"
    hand = PokerHand.build_from_string(string:)

    assert hand.full_house?
  end

  def test_assert_four_of_a_kind
    string = "2:S, 2:H, 2:D, 2:C, 3:S"
    hand = PokerHand.build_from_string(string:)

    assert hand.four_of_a_kind?
  end
end
