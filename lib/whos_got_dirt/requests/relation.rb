module WhosGotDirt
  module Requests
    # Requests for relations.
    #
    # Many APIs support the parameters below. For API-specific parameters, visit
    # the API's request class.
    #
    # @example Find related entities by name (fuzzy match).
    #   "subject": [{
    #     "name~=": "John Smith"
    #   }]
    #
    # @example Find related people with a given birth date.
    #   "subject": [{
    #     "birth_date": "2010-01-01"
    #   }]
    #
    # @example Find related people with a birth date greater than or equal to a given value.
    #   "subject": [{
    #     "birth_date>=": "2010-01-03"
    #   }]
    #
    # @example Find related people with a birth date greater than a given value.
    #   "subject": [{
    #     "birth_date>": "2010-01-02"
    #   }]
    #
    # @example Find related people with a birth date less than or equal to a given value.
    #   "subject": [{
    #     "birth_date<=": "2010-01-04"
    #   }]
    #
    # @example Find related people with a birth date less than a given value.
    #   "subject": [{
    #     "birth_date<": "2010-01-05"
    #   }]
    #
    # @example Find related entities by address (fuzzy match).
    #   "subject": [{
    #     "contact_details": [{
    #       "type": "address",
    #       "value~=": "52 London"
    #     }]
    #   }]
    #
    # @example Limit the number of responses.
    #   "limit": 5
    module Relation
    end
  end
end
