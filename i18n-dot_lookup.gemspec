# frozen_string_literal: true

require "./lib/i18n-dot_lookup/version"

Gem::Specification.new do |spec|
  spec.name          = "i18n-dot_lookup"
  spec.version       = I18nDotLookup::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.summary       = "Allow interpolation to be performed on a object's "\
                       "attribute, e.g. %{user.name}"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/fnando/i18n-dot_lookup"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "i18n"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "pry-meta"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-fnando"
  spec.add_development_dependency "simplecov"
end
