require 'cgi'

require 'active_support/core_ext/hash/indifferent_access'
require 'json-pointer'
require 'json-schema'

require 'whos_got_dirt/renderer'

require 'whos_got_dirt/request'
require 'whos_got_dirt/requests/person/open_corporates'

require 'whos_got_dirt/response'
require 'whos_got_dirt/responses/person/open_corporates'

module WhosGotDirt
  class << self
    def schemas
      @schemas ||= {}.tap do |hash|
        Dir[File.expand_path(File.join('..', '..', 'schemas', '*'), __FILE__)].each do |file|
          hash[File.basename(file, '.json')] = JSON.load(File.read(file))
        end
      end
    end
  end
end
