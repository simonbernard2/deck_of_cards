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
