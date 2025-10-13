# typed: strict
# frozen_string_literal: true

# This represents a Playing Card.
# It has the following properties: a suit, a value and a position.
class Card
  extend T::Sig

  sig { returns(String) }
  attr_accessor :suit

  sig { returns(String) }
  attr_accessor :value

  sig { returns(T.nilable(Integer)) }
  attr_accessor :position

  sig { params(suit: String, value: String, position: T.nilable(Integer)).void }
  def initialize(suit:, value:, position: nil)
    raise ArgumentError, "Invalid suit" unless Card.suits.include?(suit)
    raise ArgumentError, "Invalid value" unless Card.values.include?(value)

    @suit = T.let(suit, String)
    @value = T.let(value, String)
    @position = T.let(position, T.nilable(Integer))
  end

  sig { returns(String) }
  def color
    red? ? "red" : "black"
  end

  sig { returns(T::Boolean) }
  def red?
    Card.red_suits.include?(suit)
  end

  sig { returns(T::Boolean) }
  def black?
    Card.black_suits.include?(suit)
  end

  sig { returns(String) }
  def to_s
    "#{value} of #{suit}"
  end

  sig { params(other: Card).returns(T::Boolean) }
  def ==(other)
    other.suit == suit && other.value == value
  end

  sig { params(low_ace: T::Boolean).returns(Integer) }
  def rank(low_ace: false)
    case value
    when "A" then low_ace ? 1 : 14
    when "J" then 11
    when "Q" then 12
    when "K" then 13
    else value.to_i
    end
  end

  sig { params(other: Card).returns(Integer) }
  def <=>(other)
    rank <=> other.rank
  end

  class << self
    extend T::Sig
    sig { returns(T::Array[String]) }
    def suits
      %w[C H S D].freeze
    end

    sig { returns(T::Array[String]) }
    def red_suits
      %w[H D].freeze
    end

    sig { returns(T::Array[String]) }
    def black_suits
      %w[S C].freeze
    end

    sig { returns(T::Array[String]) }
    def values
      %w[A 2 3 4 5 6 7 8 9 10 J Q K].freeze
    end
  end
end
