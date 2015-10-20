require 'cgi'
require 'json'

require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/slice'
require 'json-pointer'
require 'json-schema'
require 'nokogiri'
require 'nori'

require 'whos_got_dirt/renderer'
require 'whos_got_dirt/result'
require 'whos_got_dirt/validator'

require 'whos_got_dirt/request'
require 'whos_got_dirt/requests/entity/corp_watch'
require 'whos_got_dirt/requests/entity/little_sis'
require 'whos_got_dirt/requests/entity/open_corporates'
require 'whos_got_dirt/requests/entity/open_duka'
require 'whos_got_dirt/requests/entity/poderopedia'
require 'whos_got_dirt/requests/list/little_sis'
require 'whos_got_dirt/requests/list/open_corporates'
require 'whos_got_dirt/requests/relation/open_corporates'
require 'whos_got_dirt/requests/relation/open_oil'

require 'whos_got_dirt/response'
require 'whos_got_dirt/responses/helpers/little_sis'
require 'whos_got_dirt/responses/helpers/open_corporates'
require 'whos_got_dirt/responses/entity/little_sis'
require 'whos_got_dirt/responses/entity/open_corporates'
require 'whos_got_dirt/responses/entity/open_duka'
require 'whos_got_dirt/responses/entity/poderopedia'
require 'whos_got_dirt/responses/list/little_sis'
require 'whos_got_dirt/responses/list/open_corporates'
require 'whos_got_dirt/responses/relation/open_corporates'
require 'whos_got_dirt/responses/relation/open_oil'

module WhosGotDirt
  class Error < StandardError; end
  class ValidationError < Error; end
end
