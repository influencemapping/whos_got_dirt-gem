module WhosGotDirt
  module Requests
    # Requests for people.
    #
    # Most APIs support the parameters below. For API-specific parameters, visit
    # the API's request class.
    # 
    # @example Find people by name (exact match).
    #   "name": "John Smith"
    #
    # @example Find people by name (fuzzy match).
    #   "name~=": "John Smith"
    #
    # @example Find people with a given birth date.
    #   "birth_date": "2010-01-01"
    #
    # @example Find people with a birth date greater than or equal to a given value.
    #   "birth_date>=": "2010-01-03"
    #
    # @example Find people with a birth date greater than a given value.
    #   "birth_date>": "2010-01-02"
    #
    # @example Find people with a birth date less than or equal to a given value.
    #   "birth_date<=": "2010-01-04"
    #
    # @example Find people with a birth date less than a given value.
    #   "birth_date<": "2010-01-05"
    #
    # @example Find people with a specific role.
    #   "memberships": [{
    #     "role": "ceo"
    #   }]
    #
    # @example Find people by address (fuzzy match).
    #   "contact_details": [{
    #     "type": "address",
    #     "value~=": "52 London"
    #   }]
    #
    # @example Limit the number of responses.
    #   "limit": 5
    module Person
    end
  end
end
