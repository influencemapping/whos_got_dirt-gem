require 'rubygems'

require 'simplecov'
require 'coveralls'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'spec'
end

require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :faraday
  c.configure_rspec_metadata!
end

require 'rspec'
require 'faraday'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f}
require File.dirname(__FILE__) + '/../lib/whos_got_dirt'
