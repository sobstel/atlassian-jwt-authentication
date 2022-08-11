source 'https://rubygems.org'

gemspec

def gems(*gems)
  gems.each { |g| gem(g) }
end

gem 'addressable'
gem 'faraday', '~> 0.11.0'

group :development do
  gems "bundler-audit",
       "rubocop-rspec",
       "rubocop-performance"
end
