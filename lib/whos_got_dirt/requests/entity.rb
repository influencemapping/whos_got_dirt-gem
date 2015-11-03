module WhosGotDirt
  module Requests
    # Requests for entities.
    #
    # Many APIs support the parameters below. For API-specific parameters, visit
    # the API's request class.
    #
    # You may filter `dissolution_date` the same as `founding_date`.
    #
    # @example Find entities by name (fuzzy match).
    #   "name~=": "ACME Inc."
    #
    # @example Find entities by classification.
    #   "classification": "Private Limited Company"
    #
    # @example Find entities with one of many classifications.
    #   "classification|=": "Private Limited Company"
    #
    # @example Find entities with a creation date greater than or equal to a given value.
    #   "created_at>=": "2010-01-01"
    #
    # @example Find organizations with a given founding date.
    #   "founding_date": "2010-01-01"
    #
    # @example Find organizations with a founding date greater than or equal to a given value.
    #   "founding_date>=": "2010-01-03"
    #
    # @example Find organizations with a founding date greater than a given value.
    #   "founding_date>": "2010-01-02"
    #
    # @example Find organizations with a founding date less than or equal to a given value.
    #   "founding_date<=": "2010-01-04"
    #
    # @example Find organizations with a founding date less than a given value.
    #   "founding_date<": "2010-01-05"
    #
    # @example Find entities by identifier.
    #   "identifiers": [{
    #     "identifier": "911653725",
    #     "scheme": "IRS Employer Identification Number"
    #   }]
    #
    # @example Find entities by address (fuzzy match).
    #   "contact_details": [{
    #     "type": "address",
    #     "value~=": "52 London"
    #   }]
    #
    # @example Limit the number of responses.
    #   "limit": 5
    module Entity
    end
  end
end
