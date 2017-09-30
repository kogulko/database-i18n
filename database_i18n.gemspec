# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'database_i18n/version'

Gem::Specification.new do |spec|
  spec.name          = "database_i18n"
  spec.version       = DatabaseI18n::VERSION
  spec.authors       = ["kogulko"]
  spec.email         = ["a.kog@rademade.com"]

  spec.summary       = %q{ Store i18n translations in database }
  spec.description   = %q{ Store your transaltions in database and use them simple as i18n rails gem }
  spec.homepage      = "https://github.com/kogulko"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "awesome_nested_set"
  spec.add_dependency "globalize", '~> 5.1.0.beta2'
end
