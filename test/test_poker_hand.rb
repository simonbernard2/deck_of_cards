# typed: true
# frozen_string_literal: true

require "test_helper"
require "debug"

class PokerHandTest < Minitest::Test
  include PokerHands

  def test_assert_hands_has_a_pair
    string = "2:H, 2:S, K:D, 5:H, 9:S"
    hand = PokerHand.build_from_string(string:)
    assert assert_instance_of PokerHands::OnePair, hand
  end

  def test_assert_hands_has_two_pairs
    string = "2:H, 2:S, K:D, K:H, 9:S"
    hand = PokerHand.build_from_string(string:)
    assert_instance_of PokerHands::TwoPairs, hand
  end

  def test_assert_hands_is_flush
    string = "2:H, 3:H, 8:H, 9:H, A:H"
    hand = PokerHand.build_from_string(string:)
    assert_instance_of PokerHands::Flush, hand
  end

  def test_assert_hands_is_a_straight
    string = "A:S, 2:H, 3:H, 4:H, 5:H"
    hand = PokerHand.build_from_string(string:)
    assert_instance_of PokerHands::Straight, hand

    string = "10:S, J:H, Q:H, K:H, A:H"
    hand = PokerHand.build_from_string(string:)
    assert_instance_of PokerHands::Straight, hand
  end

  def test_assert_hand_is_full_house
    string = "2:S, 2:H, 2:D, 3:H, 3:S"
    hand = PokerHand.build_from_string(string:)

    assert_instance_of PokerHands::FullHouse, hand
  end

  def test_assert_four_of_a_kind
    string = "2:S, 2:H, 2:D, 2:C, 3:S"
    hand = PokerHand.build_from_string(string:)

    assert_instance_of PokerHands::FourOfAKind, hand
  end

  def test_pair_beats_high_card
    pair = PokerHand.build_from_string(string: "2:H, 2:S, K:D, 5:H, 9:S")
    high_card = PokerHand.build_from_string(string: "2:H, 3:S, K:D, 5:H, 9:S")

    assert pair > high_card
  end

  def test_highcard_beats_high_card
    weakest_hand = PokerHand.build_from_string(string: "2:H, 3:S, K:D, 5:H, 9:S")
    strongest_hand = PokerHand.build_from_string(string: "2:H, 3:S, K:D, 5:H, A:S")

    assert strongest_hand > weakest_hand
  end

  def test_highest_pair_beats_lowest_pair
    low_pair = PokerHand.build_from_string(string: "2:H, 2:S, K:D, 5:H, 9:S")
    high_pair = PokerHand.build_from_string(string: "A:H, A:S, K:D, 5:H, 9:S")

    assert high_pair > low_pair
  end

  def test_equal_pair_wins_by_kicker
    low_pair = PokerHand.build_from_string(string: "2:H, 2:S, K:D, 5:H, 9:S")
    high_pair = PokerHand.build_from_string(string: "2:H, 2:S, K:D, 5:H, A:S")

    assert high_pair > low_pair
  end

  def test_two_pairs_beats_two_pairs
    losing_hand = PokerHand.build_from_string(string: "2:H, 2:S, K:D, K:H, 9:S")
    winning_hand = PokerHand.build_from_string(string: "A:H, A:S, K:D, K:H, 9:S")

    assert winning_hand > losing_hand

    losing_hand = PokerHand.build_from_string(string: "2:H, 2:S, K:D, K:H, 9:S")
    winning_hand = PokerHand.build_from_string(string: "2:H, 2:S, K:D, K:H, 10:S")

    assert winning_hand > losing_hand
  end

  def test_three_of_a_kind
    winner = PokerHand.build_from_string(string: "3:H, 3:S, 3:D, 8:S, 9:S")
    looser = PokerHand.build_from_string(string: "2:H, 2:S, 2:D, 8:S, 9:S")

    assert winner > looser

    winner = PokerHand.build_from_string(string: "3:H, 3:S, 3:D, 10:S, 9:S")
    looser = PokerHand.build_from_string(string: "3:H, 3:S, 3:D, 8:S, 9:S")

    assert winner > looser
  end

  def test_straight
    winner = PokerHand.build_from_string(string: "2:D, 3:C, 4:S, 5:H, 6:S")
    loser = PokerHand.build_from_string(string: "A:C, 2:D, 3:C, 4:S, 5:H")

    assert winner > loser, "2 to 6 beats A to 5"

    winner = PokerHand.build_from_string(string: "10:D, J:C, Q:S, K:H, A:S")
    loser = PokerHand.build_from_string(string: "A:C, 2:D, 3:C, 4:S, 5:H")

    assert winner > loser, "10 to A beats A to 5"
  end

  def test_flush
    first_hand = PokerHand.build_from_string(string: "2:H, 3:H, 8:H, 9:H, A:H")
    second_hand = PokerHand.build_from_string(string: "2:D, 3:D, 8:D, 9:D, A:D")

    assert_equal first_hand, second_hand
  end

  def test_full_house
    winner = PokerHand.build_from_string(string: "3:S, 3:H, 3:D, 2:H, 2:S")
    loser = PokerHand.build_from_string(string: "2:S, 2:H, 2:D, 3:H, 3:S")

    assert winner > loser

    winner = PokerHand.build_from_string(string: "3:S, 3:H, 3:D, 4:H, 4:S")
    loser = PokerHand.build_from_string(string: "3:S, 3:H, 3:D, 2:H, 2:S")

    assert winner > loser
  end

  def four_of_a_kind
    winner = PokerHand.build_from_string(string: "3:C, 3:H, 3:S, 3:D, A:H")
    loser = PokerHand.build_from_string(string: "2:C, 2:H, 2:S, 2:D, A:H")

    assert winner > loser
  end

  def test_straight_flush
    winner = PokerHand.build_from_string(string: "2:S, 3:S, 4:S, 5:S, 6:S")
    loser = PokerHand.build_from_string(string: "2:H, 3:H, 4:H, 5:H, A:H")

    assert winner > loser, "2 to 6 beats A to 5"

    winner = PokerHand.build_from_string(string: "10:S, J:S, Q:S, K:S, A:S")
    loser = PokerHand.build_from_string(string: "A:H, 2:H, 3:H, 4:H, 5:H")

    assert winner > loser, "10 to A beats A to 5"
  end
end
