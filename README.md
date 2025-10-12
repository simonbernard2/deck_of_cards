# deck_of_cards_handler

**deck_of_cards_handler** is a Ruby gem for parsing, validating,
and manipulating playing-card packets and decks.

It provides utilities to load, inspect, and compare cards
from text files or strings, with built-in validation and Sorbet type checking.

---

## 📦 Installation

Add to your Gemfile:

```ruby
gem "deck_of_cards_handler"

Then install:

bundle install
# or
gem install deck_of_cards_handler


⸻

🃏 Usage

require "deck_of_cards_handler"

# Build a packet from a string
packet = DeckOfCardsHandler::Packet.build_from_string("AS, KD, 7C, 10H")

packet.size      # => 4
packet.first     # => #<Card A♠>
packet.last      # => #<Card 10♥>
packet.each { |card| puts card }  # Prints A♠, K♦, 7♣, 10♥

Load a packet from a file:

packet = DeckOfCardsHandler::Packet.build_from_text_file("data/mnemonica.txt")

Validate input and handle errors:

begin
  DeckOfCardsHandler::Packet.build_from_string("AX, 2S")
rescue DeckOfCardsHandler::InvalidCardError => e
  puts e.message  # => "Invalid rank or suit at token: AX"
end


⸻

⚙️ Features
 • Parse and validate cards from strings or text files
 • Detect duplicates and invalid formats
 • Iterate and compare cards using Ruby’s Enumerable and Comparable
 • Includes Sorbet type signatures for static safety
 • Simple integration with text-based deck definitions (e.g., Mnemonica)

⸻

🧪 Development

After checking out the repo, run:

bin/setup

This installs dependencies.

Run the test suite:

rake test

You can also open an interactive console for experimentation:

bin/console


⸻

🚀 Installation & Release

To install this gem onto your local machine:

bundle exec rake install

⸻

🤝 Contributing

Bug reports and pull requests are welcome on GitHub:
github.com/simonbernard2/deck_of_cards


📜 License

Released under the MIT License.
See LICENSE.txt for details.

