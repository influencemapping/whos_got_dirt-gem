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
  'birth_date>=' => '1950-01-01',
  'birth_date<=' => '1959-12-31',
  'memberships' => [{
    'role' => 'ceo',
    'status' => 'active',
  }],
  'contact_details' => [{
    'type' => 'address',
    'value' => '52 London',
  }],
  'open_corporates_api_key' => '...',
}

url = WhosGotDirt::Requests::Person::OpenCorporates.new(params).to_s
#=> "https://api.opencorporates.com/officers/search?q=John+Smith&jurisdiction_code=gb%7Cie&date_of_birth=1950-01-01%3A1959-12-31&position=ceo&inactive=false&address=52+London&api_token=...&per_page=100&order=score"

response = Farady.get(url)

results = WhosGotDirt::Responses::Person::OpenCorporates.new(response).to_a
#=> @todo
```

## Acknowledgements

Most terms are from [Popolo](http://www.popoloproject.com/). The request and response formats are inspired from the [Metaweb Query Language](http://mql.freebaseapps.com/index.html) and the [OpenRefine Reconciliation Service API](https://github.com/OpenRefine/OpenRefine/wiki/Reconciliation-Service-API).

Copyright (c) 2015 James McKinney, released under the MIT license
