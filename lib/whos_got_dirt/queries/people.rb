module WhosGotDirt
  module Queries
    # Federated search for people.
    # 
    # * `birth_date`: match identical birth date `YYYY-MM-DD`
    # * `birth_date>`: match birth date greater than value
    # * `birth_date>=`: match birth date greater than or equal to value
    # * `birth_date<`: match birth date less than value
    # * `birth_date<=`: match birth date lessn than or equal to value
    #
    # @example
    #   "memberships": [{
    #     "role": "ceo"
    #   }]
    #
    # @example
    #   "memberships": [{
    #     "status": "active"
    #   }]
    #
    # @example
    #   "memberships": [{
    #     "status": "inactive"
    #   }]
    #
    # @example
    #   "contact_details": [{
    #     "type": "address",
    #     "value": "52 London"
    #   }]
    module People
    end
  end
end
