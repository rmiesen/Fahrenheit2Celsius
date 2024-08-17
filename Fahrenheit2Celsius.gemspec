# frozen_string_literal: true

require_relative "lib/Fahrenheit2Celsius/version"

Gem::Specification.new do |spec|
  spec.name = "Fahrenheit2Celsius"
  spec.version = Fahrenheit2Celsius::VERSION
  spec.authors = ["Robert Miesen"]
  spec.email = ["robert.miesen@gmail.com"]

  spec.summary = "Convert Fahrenheit Celsius, Kelvin, and each way in-between"
  spec.description = "Convert Fahrenheit Celsius, Kelvin, and each way in-between."
  spec.homepage = "https://github.com/rmiesen/Fahrenheit2Celsius"
  spec.license = "EPL-2.0"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rmiesen/Fahrenheit2Celsius"
  spec.metadata["changelog_uri"] = "https://github.com/rmiesen/Fahrenheit2Celsius/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
