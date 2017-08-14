# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "htpc/version"

Gem::Specification.new do |spec|
  spec.name          = "htpc-cli"
  spec.version       = Htpc::VERSION
  spec.authors       = ["Joe LaSala"]
  spec.email         = ["joe@frontside.io"]

  spec.summary       = 'A suite of Home Theater PC management tools favoring convention over configuration'
  spec.description   = 'A suite of Home Theater PC management tools favoring convention over configuration'
  spec.homepage      = "https://github.com/sadatay/htpc-cli"

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
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency('rake')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('pry-byebug')

  spec.add_runtime_dependency('clamp')
  spec.add_runtime_dependency('psych')
  spec.add_runtime_dependency('hashugar')
  spec.add_runtime_dependency('tty')
  spec.add_runtime_dependency('highline')
  spec.add_runtime_dependency('omdbapi')

  spec.add_development_dependency "bundler", "~> 1.15"
end
