# frozen_string_literal: true

require_relative "lib/deck_of_cards/version"

Gem::Specification.new do |spec|
  spec.name = "deck_of_cards"
  spec.version = DeckOfCards::VERSION
  spec.authors = ["Simon Bernard"]
  spec.email = ["simonbernard@gmail.com"]

  spec.summary = "A gem that simulates the handling of a deck of cards"
  spec.description = <<-DESC
    It provides all the moves one could do with a deck of cards.
    Such as shuffling, cutting, dealing, culling, etc.
  DESC
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sorbet-runtime"
  spec.add_development_dependency "sorbet"
  spec.add_development_dependency "tapioca", ">= 0.17.7"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
