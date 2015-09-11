# Who's got dirt? A federated search API for people and organizations

[![Gem Version](https://badge.fury.io/rb/whos_got_dirt.svg)](https://badge.fury.io/rb/whos_got_dirt)
[![Build Status](https://secure.travis-ci.org/influencemapping/whos_got_dirt-gem.png)](https://travis-ci.org/influencemapping/whos_got_dirt-gem)
[![Dependency Status](https://gemnasium.com/influencemapping/whos_got_dirt-gem.png)](https://gemnasium.com/influencemapping/whos_got_dirt-gem)
[![Coverage Status](https://coveralls.io/repos/influencemapping/whos_got_dirt-gem/badge.svg)](https://coveralls.io/r/influencemapping/whos_got_dirt-gem)
[![Code Climate](https://codeclimate.com/github/influencemapping/whos_got_dirt-gem.png)](https://codeclimate.com/github/influencemapping/whos_got_dirt-gem)

## Usage

This gem provides a common API to multiple APIs. See the [server](https://github.com/influencemapping/whos_got_dirt-server) for a deployment.

To add support for new APIs, see the documentation for [Request](http://www.rubydoc.info/gems/whos_got_dirt/WhosGotDirt/Request) and [Response](http://www.rubydoc.info/gems/whos_got_dirt/WhosGotDirt/Response).

In this example, we convert generic API parameters to an OpenCorporates API URL, and request the URL with [Faraday](https://github.com/lostisland/faraday). Then, we convert the OpenCorporates API response to a generic API response.

```ruby
require 'whos_got_dirt'
require 'faraday'

params = {
  'name~=' => 'John Smith',
  'jurisdiction_code|=' => ['gb', 'ie'],
  'memberships' => [{
    'role' => 'director',
    'inactive' => false,
  }],
}

url = WhosGotDirt::Requests::Person::OpenCorporates.new(params).to_s
#=> "https://api.opencorporates.com/officers/search?q=John+Smith&position=director&inactive=false&jurisdiction_code=gb%7Cie&order=score"

response = Faraday.get(url)

results = WhosGotDirt::Responses::Person::OpenCorporates.new(response).to_a
#=> [{"@type"=>"Person",
#  "name"=>"JOHN SMITH",
#  "updated_at"=>"2014-10-25T00:34:16+00:00",
#  "identifiers"=>[{"identifier"=>"46065070", "scheme"=>"OpenCorporates"}],
#  "contact_details"=>[],
#  "links"=>[{"url"=>"https://opencorporates.com/officers/46065070", "note"=>"OpenCorporates URL"}],
#  "memberships"=>
#   [{"role"=>"director",
#     "start_date"=>"2006-11-24",
#     "organization"=>
#      {"name"=>"EVOLUTION (GB) LIMITED",
#       "identifiers"=>[{"identifier"=>"05997209", "scheme"=>"Company Register"}],
#       "links"=>[{"url"=>"https://opencorporates.com/companies/gb/05997209", "note"=>"OpenCorporates URL"}],
#       "jurisdiction_code"=>"gb"}}],
#  "current_status"=>"CURRENT",
#  "jurisdiction_code"=>"gb",
#  "occupation"=>"MANAGER",
#  "sources"=>
#   [{"url"=>"https://api.opencorporates.com/officers/search?inactive=false&jurisdiction_code=gb%7Cie&order=score&position=director&q=John+Smith", "note"=>"OpenCorporates"}]},
#  ...]
```

## Acknowledgements

Most terms are from [Popolo](http://www.popoloproject.com/). The request and response formats are inspired from the [Metaweb Query Language](http://mql.freebaseapps.com/index.html) and the [OpenRefine Reconciliation Service API](https://github.com/OpenRefine/OpenRefine/wiki/Reconciliation-Service-API).

Copyright (c) 2015 James McKinney, released under the MIT license
