# frozen_string_literal: true
# typed: strict

module PokerHands
  class HighCard < PokerHand
    sig { override.returns(Integer) }
    def rank
      1
    end
  end
end
