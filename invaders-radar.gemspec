# frozen_string_literal: true

require_relative "lib/invaders/radar/version"

Gem::Specification.new do |spec|
  spec.name = "invaders-radar"
  spec.version = Invaders::Radar::VERSION
  spec.authors = ["barrerajl"]
  spec.email = ["jluis.barrera@gmail.com"]

  spec.summary = "Radar detector for space-invadores"
  spec.description = "Space invaders are upon us!" \
                     "Take a radar sample as an argument and reveal possible locations of those pesky invaders"
  spec.homepage = "https://github.com"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://github.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com"
  spec.metadata["changelog_uri"] = "https://github.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pastel", "~> 0.8"
  spec.add_dependency "slop", "~> 4.9"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
