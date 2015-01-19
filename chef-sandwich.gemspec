require File.expand_path("../lib/sandwich/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'chef-sandwich'
  gem.version = Sandwich::VERSION

  gem.summary     = 'The easiest way to get started as a chef'
  gem.author      = 'Sebastian Boehm'
  gem.email       = 'sebastian@sometimesfood.org'
  gem.homepage    = 'https://github.com/sometimesfood/sandwich'
  gem.license     = 'Apache License (2.0)'

  gem.description = <<EOS
Sandwich lets you apply Chef recipes to your system without having to
worry about cookbooks or configuration.
EOS

  gem.add_dependency('chef', '~> 11.12.8')
  gem.add_dependency('uuidtools', '~> 2.1.5')

  gem.add_development_dependency('minitest', '~> 5.5.1')
  gem.add_development_dependency('fakefs', '~> 0.6.4')
  gem.add_development_dependency('rake', '~> 10.4.2')

  # ensure the gem is built out of versioned files
  gem.files = Dir['Rakefile',
                  'README.md',
                  'LICENSE',
                  'NEWS',
                  '{bin,lib,man,spec}/**/*'] \
              & `git ls-files -z`.split("\0")
  gem.executables = ['sandwich']
end
