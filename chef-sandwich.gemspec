require File.expand_path("../lib/sandwich/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'chef-sandwich'
  gem.version = Sandwich::Version

  gem.summary     = 'The easiest way to get started as a chef'
  gem.author      = 'Sebastian Boehm'
  gem.email       = 'sebastian@sometimesfood.org'
  gem.homepage    = 'https://github.com/sometimesfood/sandwich'

  gem.description = <<EOS
Sandwich lets you apply Chef recipes to your system without having to
worry about cookbooks or configuration.
EOS

  gem.has_rdoc    = 'yard'

  gem.add_dependency('chef', ['>= 0.9'])

  # ensure the gem is built out of versioned files
  gem.files = Dir['Rakefile',
                  'README.md',
                  'LICENSE',
                  'NEWS',
                  '{bin,lib,man,test,spec}/**/*'] \
              & `git ls-files -z`.split("\0")
  gem.executables = ['sandwich']
end
