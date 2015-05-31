require 'rubygems'

require 'simplecov'
require 'coveralls'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'spec'
end

require 'faraday'

require 'rspec'
require File.dirname(__FILE__) + '/../lib/whos_got_dirt'
