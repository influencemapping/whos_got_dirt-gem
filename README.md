# Who's got dirt? A federated search API for entities and relations

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

input = {
  'subject' => [{
    'name~=' => 'John Smith',
  }],
  'jurisdiction_code|=' => ['gb', 'ie'],
  'role' => 'director',
  'inactive' => false,
}

url = WhosGotDirt::Requests::Relation::OpenCorporates.new(input).to_s
#=> "https://api.opencorporates.com/officers/search?q=John+Smith&jurisdiction_code=gb%7Cie&position=director&inactive=false&order=score"

response = Faraday.get(url)

results = WhosGotDirt::Responses::Relation::OpenCorporates.new(response).to_a
#=> [{"@type"=>"Relation",
#  "subject"=>
#   {"name"=>"JOHN SMITH",
#    "contact_details"=>[{"type"=>"address"}],
#    "occupation"=>"CONTRACTS DIRECTORS"},
#  "object"=>
#   {"name"=>"IMPERIAL DUCTWORK SERVICES HOLDINGS LIMITED",
#    "identifiers"=>[{"identifier"=>"08484366", "scheme"=>"Company Register"}],
#    "links"=>[{"url"=>"https://opencorporates.com/companies/gb/08484366", "note"=>"OpenCorporates URL"}],
#    "jurisdiction_code"=>"gb"},
#  "start_date"=>"2013-04-30",
#  "identifiers"=>[{"identifier"=>"71863990", "scheme"=>"OpenCorporates"}],
#  "links"=>[{"url"=>"https://opencorporates.com/officers/71863990", "note"=>"OpenCorporates URL"}],
#  "updated_at"=>"2014-10-13T13:57:58+00:00",
#  "current_status"=>"CURRENT",
#  "jurisdiction_code"=>"gb",
#  "role"=>"director",
#  "sources"=>[{"url"=>"https://api.opencorporates.com/officers/search?inactive=false&jurisdiction_code=gb%7Cie&order=score&position=director&q=John+Smith", "note"=>"OpenCorporates"}]},
#  ...]
```

## Acknowledgements

Most terms are from [Popolo](http://www.popoloproject.com/). The request and response formats are inspired from the [Metaweb Query Language](http://mql.freebaseapps.com/index.html) and the [OpenRefine Reconciliation Service API](https://github.com/OpenRefine/OpenRefine/wiki/Reconciliation-Service-API).

Copyright (c) 2015 James McKinney, released under the MIT license
