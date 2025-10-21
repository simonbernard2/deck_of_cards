[![Gem Version](https://badge.fury.io/rb/deck_of_cards_handler.svg?branch=master&kill_cache=1)](https://badge.fury.io/rb/deck_of_cards_handler) [![Test suite](https://github.com/simonbernard2/deck_of_cards/actions/workflows/ruby.yml/badge.svg)](https://github.com/simonbernard2/deck_of_cards/actions/workflows/ruby.yml)

# Deck of cards handler

A ruby gem for simulating real-world deck handling: shuffle, cut, deal, cull
and more.

## Installation

Run the following terminal command:

```zsh
gem install deck_of_cards_handler
```

## Quickstart

```ruby
require "deck_of_cards_handler"

# Cards
c = Card.new(suit: "S", value: "A")
c.red?        # => false
c.black?      # => true
c.spades?      # => true
c.hearts?      # => false
c.to_s        # => "A of S"
c.rank        # => 14 (Ace high)

Card.suits       # => ["C","D","H","S"]
Card.values      # => ["A","2",...,"10","J","Q","K"]

# Packets (decks or piles)
deck = Packet.new                    # empty unless you pass cards
one_card = Packet.new(cards: [c])
full = Packet.build_from_text_file(file_path: "data/mnemonica.txt")
five = Packet.build_from_string(string: "A:C, K:D, Q:H, J:S, 10:C")

full.size                            # => 52
full.shuffle                         # in-place shuffle
full.reverse                         # in-place reverse
top = full.top_deal                  # remove and return top card (Card)
sec = full.second_deal               # remove and return second card (Card)
bot = full.bottom_deal               # remove and return bottom card (Card)

piles = full.deal_into_piles(number_of_piles: 4, number_of_cards: 5)
# => [[Card,...],[...],[...],[...]]

# Reassemble piles (all return Packet)
full.reassemble_left_to_right_on_top(piles)

# Packet ↔︎ Poker hand
hand = five.to_poker_hand            # => a PokerHands::PokerHand subclass

```

## Shuffling

```ruby
# Perfect interleaving (Faro)
top_half = deck.cut(number: 26)
deck.faro(other_packet: top_half)

# Imperfect riffle shuffle
left_half = deck.cut(number: 26)
deck.riffle_shuffle(other_packet: left_half)

# Random shuffle
deck.shuffle

```

## Convert Packets to Poker Hand

```ruby
five = Packet.build_from_string(string: "A:C, K:D, Q:H, J:S, 10:C")
hand = five.to_poker_hand   # => PokerHands::Straight
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
    #...
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

  piles = deck.deal_into_piles(number_of_piles: 5, number_of_cards: 5)

  hands = piles.map(&:to_poker_hand)
  # => [#PokerHands::OnePair, [...],[...],[...],[...]]
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
