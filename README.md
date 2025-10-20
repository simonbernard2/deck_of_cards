[![Gem Version](https://badge.fury.io/rb/deck_of_cards_handler.svg)](https://badge.fury.io/rb/deck_of_cards_handler)

# Deck of cards handler

A ruby gem for simulating real-world deck handling: shuffle, cut, deal, cull
and more.

## Installation

Run the following terminal command:

```zsh
gem install deck_of_cards_handler
```

## Usage examples

<details>
<summary>Create the Mnemonica stack from Stay Stack</summary>

```ruby
  require "deck_of_cards_handler"

  # create a deck in stay stack order
  clubs = Card.values.map { Card.new(suit: "C", value: _1) }
  hearts = Card.values.map { Card.new(suit: "H", value: _1) }
  diamonds = Card.values.map { Card.new(suit: "D", value: _1) }
  spades = Card.values.map { Card.new(suit: "S", value: _1) }
  deck = Packet.new(cards: [clubs, hearts, diamonds.reverse, spades.reverse].flatten)

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
  # assign a position value to the cards
  deck.set_cards_positions

  deck
#  =>
# <Packet:0x000000012ae2b848
#  @cards=
    [#<Card:0x000000012ae2bd20 @position=1, @suit="S", @value="4">,
    #<Card:0x000000012ae2cae0 @position=2, @suit="H", @value="2">,
    #<Card:0x000000012ae2c220 @position=3, @suit="D", @value="7">,
    #<Card:0x000000012ae2bd98 @position=4, @suit="S", @value="3">,
    #<Card:0x000000012ae2c9f0 @position=5, @suit="H", @value="4">,
    #<Card:0x000000012ae2c298 @position=6, @suit="D", @value="6">,
    #<Card:0x000000012ae2df08 @position=7, @suit="C", @value="A">,
    #<Card:0x000000012ae2c978 @position=8, @suit="H", @value="5">,
    #<Card:0x000000012ae2ce00 @position=9, @suit="C", @value="9">,
    #<Card:0x000000012ae2d260 @position=10, @suit="C", @value="2">,
    #<Card:0x000000012ae2c630 @position=11, @suit="H", @value="Q">,
    #<Card:0x000000012ae2c400 @position=12, @suit="D", @value="3">,
    #<Card:0x000000012ae2b960 @position=13, @suit="S", @value="Q">,
    #<Card:0x000000012ae2c810 @position=14, @suit="H", @value="8">,
    #<Card:0x000000012ae2cf68 @position=15, @suit="C", @value="6">,
    #<Card:0x000000012ae2cfe0 @position=16, @suit="C", @value="5">,
    #<Card:0x000000012ae2c798 @position=17, @suit="H", @value="9">,
    #<Card:0x000000012ae2b8e8 @position=18, @suit="S", @value="K">,
    #<Card:0x000000012ae2c478 @position=19, @suit="D", @value="2">,
    #<Card:0x000000012ae2c6a8 @position=20, @suit="H", @value="J">,
    #<Card:0x000000012ae2d0d0 @position=21, @suit="C", @value="3">,
    #<Card:0x000000012ae2ce78 @position=22, @suit="C", @value="8">,
    #<Card:0x000000012ae2c900 @position=23, @suit="H", @value="6">,
    #<Card:0x000000012ae2ba50 @position=24, @suit="S", @value="10">,
    #<Card:0x000000012ae2c310 @position=25, @suit="D", @value="5">,
    #<Card:0x000000012ae2bf50 @position=26, @suit="D", @value="K">,
    #<Card:0x000000012ae2be10 @position=27, @suit="S", @value="2">,
    #<Card:0x000000012ae2ca68 @position=28, @suit="H", @value="3">,
    #<Card:0x000000012ae2c1a8 @position=29, @suit="D", @value="8">,
    #<Card:0x000000012ae2bca8 @position=30, @suit="S", @value="5">,
    #<Card:0x000000012ae2cc20 @position=31, @suit="C", @value="K">,
    #<Card:0x000000012ae2c040 @position=32, @suit="D", @value="J">,
    #<Card:0x000000012ae2bb40 @position=33, @suit="S", @value="8">,
    #<Card:0x000000012ae2cd88 @position=34, @suit="C", @value="10">,
    #<Card:0x000000012ae2c5b8 @position=35, @suit="H", @value="K">,
    #<Card:0x000000012ae2b9d8 @position=36, @suit="S", @value="J">,
    #<Card:0x000000012ae2cef0 @position=37, @suit="C", @value="7">,
    #<Card:0x000000012ae2c720 @position=38, @suit="H", @value="10">,
    #<Card:0x000000012ae2c4f0 @position=39, @suit="D", @value="A">,
    #<Card:0x000000012ae2d058 @position=40, @suit="C", @value="4">,
    #<Card:0x000000012ae2c888 @position=41, @suit="H", @value="7">,
    #<Card:0x000000012ae2c388 @position=42, @suit="D", @value="4">,
    #<Card:0x000000012ae2be88 @position=43, @suit="S", @value="A">,
    #<Card:0x000000012ae2bac8 @position=44, @suit="S", @value="9">,
    #<Card:0x000000012ae2cd10 @position=45, @suit="C", @value="J">,
    #<Card:0x000000012ae2bfc8 @position=46, @suit="D", @value="Q">,
    #<Card:0x000000012ae2bbb8 @position=47, @suit="S", @value="7">,
    #<Card:0x000000012ae2cc98 @position=48, @suit="C", @value="Q">,
    #<Card:0x000000012ae2c0b8 @position=49, @suit="D", @value="10">,
    #<Card:0x000000012ae2bc30 @position=50, @suit="S", @value="6">,
    #<Card:0x000000012ae2cb58 @position=51, @suit="H", @value="A">,
    #<Card:0x000000012ae2c130 @position=52, @suit="D", @value="9">]>
```

</details>

<details>
<summary>Distribute 5 hands of poker</summary>

```ruby
  require "deck_of_cards_handler"

  # create a full deck of cards
  cards = []
  Card.suits.each do |suit|
    Card.values.each do |value|
      cards << Card.new(suit:, value:)
    end
  end
  deck = Packet.new(cards:)

  deck.shuffle

  hands = deck.deal_into_piles(number_of_piles: 5, number_of_cards: 5)

  hands.map(&:to_s)
  # => [["5 of D", "8 of C", "6 of S", "10 of D", "5 of C"], ["7 of C", "5 of S", "4 of C", "2 of D", "Q of D"], ["3 of S", "8 of D", "A of D", "2 of C", "7 of D"], ["Q of H", "4 of S", "3 of D", "J of S", "9 of S"], ["6 of C", "6 of H", "10 of C", "4 of D", "A of H"]]
```

</details>

## Development

After checking out the repo, run:

```zsh
bin/setup
```

This installs dependencies.

Run the test suite:

```zsh
rake test
```

You can also open an interactive console for experimentation:

```zsh
bin/console
```
