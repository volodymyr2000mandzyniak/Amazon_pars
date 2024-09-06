# amazon_pars.gemspec
require_relative "lib/amazon_pars/version"

Gem::Specification.new do |spec|
  spec.name          = "amazon_pars"
  spec.version       = AmazonPars::VERSION
  spec.authors       = ["Volodymyr"]
  spec.email         = ["volodimirmandzyniak@gmail.com"]

  spec.summary       = %q{Amazon Job Scraper}
  spec.description   = %q{A Ruby gem that scrapes job listings from Amazon's career website.}
  spec.homepage      = "https://github.com/volodymyr2000mandzyniak/amazon_pars"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "README.md", "Gemfile"]
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "capybara", "~> 3.40"
  spec.add_runtime_dependency "selenium-webdriver", "~> 4.0"

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
end
