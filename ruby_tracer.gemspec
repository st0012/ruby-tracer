# frozen_string_literal: true

require_relative "lib/ruby_tracer/version"

Gem::Specification.new do |spec|
  spec.name = "ruby_tracer"
  spec.version = Tracer::VERSION
  spec.authors = ["Stan Lo"]
  spec.email = ["stan001212@gmail.com"]

  spec.summary = "A Ruby tracer"
  spec.description = "A Ruby tracer"
  spec.homepage = "https://github.com/st0012/ruby_tracer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/st0012/ruby_tracer"
  spec.metadata[
    "changelog_uri"
  ] = "https://github.com/st0012/ruby_tracer/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files =
    Dir.chdir(__dir__) do
      `git ls-files -z`.split("\x0")
        .reject do |f|
          (f == __FILE__) ||
            f.match(
              %r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)}
            )
        end
    end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "irb", ">= 1.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
