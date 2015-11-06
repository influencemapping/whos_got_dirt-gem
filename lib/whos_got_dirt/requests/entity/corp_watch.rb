module WhosGotDirt
  module Requests
    module Entity
      # Requests for companies from the CorpWatch API.
      #
      # By default, name and address queries will match complete words only in
      # the same order as in the query, tokens less than three characters long
      # will be ignored, and MySQL's [stopwords](http://dev.mysql.com/doc/refman/5.0/en/fulltext-stopwords.html)
      # will be ignored. If `substring_match` is `1`, queries will match within
      # words as well as complete words, at a severe performance penalty.
      #
      # @example Supply an API key.
      #   "corp_watch_api_key": "..."
      #
      # @example Find entities by IRS Employer Identification Number (EIN).
      #   "identifiers": [{
      #     "identifier": "911653725",
      #     "scheme": "IRS Employer Identification Number"
      #   }]
      #
      # @example Find entities by SEC Central Index Key (CIK).
      #   "identifiers": [{
      #     "identifier": "37996",
      #     "scheme": "SEC Central Index Key"
      #   }]
      #
      # @example Find companies by SIC code.
      #   "industry_code": "2011"
      #
      # @example Find companies by SIC sector.
      #   "sector_code": "4100"
      #
      # @example Match within words on name and address queries.
      #   "substring_match": 1
      #
      # @example Find companies by country code.
      #   "country_code": "US"
      #
      # @example Find companies by country subdivision code.
      #   "subdiv_code": "OR"
      #
      # @example Find companies with SEC filings in a given year.
      #   "year": 2005
      #
      # @example Find companies with SEC filings in or before a given year.
      #   "year>=": 2003
      #
      # @example Find companies with SEC filings in or after a given year.
      #   "year<=": 2007
      #
      # @example Find companies that appear as "filers" in SEC filings or as
      # subsidiaries ("relationships") only.
      #   "source_type": "relationships"
      #
      # @example Find companies with three direct descendants in a hierarchy.
      #   "num_children": 3
      #
      # @example Find companies with two direct ancestors in a hierarchy.
      #   "num_parents": 2
      #
      # @example Find companies within the hierarchy of another company.
      #   "top_parent_id": "cw_7324"
      class CorpWatch < Request
        @base_url = 'http://api.corpwatch.org/%<year>s/companies.json'

        # Returns the URL to request.
        #
        # @return [String] the URL to request
        def to_s
          params = convert
          if params.key?(:year)
            "#{base_url % params.slice(:year).symbolize_keys}?#{to_query(params.except(:year))}"
          else
            "http://api.corpwatch.org/companies.json?#{to_query(params)}"
          end
        end

        # Converts the MQL parameters to API-specific parameters.
        #
        # @return [Hash] API-specific parameters
        # @see http://api.corpwatch.org/documentation/api_examples.html#A17
        def convert
          match('company_name', 'name')
          equal('limit', 'limit')

          input['identifiers'] && input['identifiers'].each do |identifier|
            case identifier['scheme']
            when 'IRS Employer Identification Number'
              equal('irs_number', 'identifier', input: identifier)
            when 'SEC Central Index Key'
              equal('cik', 'identifier', input: identifier)
            end
          end

          input['contact_details'] && input['contact_details'].each do |contact_detail|
            if contact_detail['type'] == 'address' && (contact_detail['value'] || contact_detail['value~='])
              output['raw_address'] = contact_detail['value'] || contact_detail['value~=']
            end
          end

          # API-specific parameters.
          equal('key', 'corp_watch_api_key')
          # http://api.corpwatch.org/documentation/api_examples.html#A35
          equal('sic_code', 'industry_code')
          equal('sic_sector', 'sector_code')
          equal('substring_match', 'substring_match', valid: [1])
          # http://api.corpwatch.org/documentation/api_examples.html#A36
          equal('country_code', 'country_code', transform: lambda{|v| v.upcase})
          equal('subdiv_code', 'subdiv_code', transform: lambda{|v| v.upcase})
          equal('year', 'year')
          equal('min_year', 'year>=')
          equal('max_year', 'year<=')
          equal('source_type', 'source_type')
          equal('num_children', 'num_children')
          equal('num_parents', 'num_parents')
          equal('top_parent_id', 'top_parent_id')

          output
        end
      end
    end
  end
end
