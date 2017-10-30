# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "crowi/client/version"

Gem::Specification.new do |spec|
  spec.name          = "crowi-client"
  spec.version       = Crowi::Client::VERSION
  spec.authors       = ["Ryu Sato"]
  spec.email         = ["tatsurou313@gmail.com"]

  spec.summary       = %q{Client of crowi}
  spec.description   = %q{crowi-client is client of crowi with use API.}
  spec.homepage      = "https://github.com/ryu-sato/crowi-client"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
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

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-json_matcher", "~> 0.1"
  spec.add_development_dependency "rest-client", "~> 2.0"
  spec.add_development_dependency "json", "~> 2.1"
  spec.add_development_dependency "easy_settings", "~> 0.1"
end
