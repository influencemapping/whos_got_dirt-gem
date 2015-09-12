module WhosGotDirt
  module Requests
    # Requests for organizations.
    #
    # You may filter `dissolution_date` the same as `founding_date`.
    #
    # @example Find organizations by name (exact match).
    #   "name": "ACME Inc."
    #
    # @example Find organizations by name (fuzzy match).
    #   "name~=": "ACME Inc."
    #
    # @example Find organizations by classification.
    #   "classification": "Private Limited Company"
    #
    # @example Find organizations with a creation date greater than or equal to a given value.
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
    # @example Find organizations by address (fuzzy match).
    #   "contact_details": [{
    #     "type": "address",
    #     "value": "52 London"
    #   }]
    #
    # @example Limit the number of responses.
    #   "limit": 5
    module Organization
    end
  end
end
