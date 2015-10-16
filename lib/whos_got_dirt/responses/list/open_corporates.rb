module WhosGotDirt
  module Responses
    module List
      # Converts corporate groupings from the OpenCorporates API to Popolo format.
      #
      # @see http://api.opencorporates.com/documentation/REST-API-introduction
      class OpenCorporates < Helpers::OpenCorporatesHelper
        @template = {
          '@type' => 'ListItem',
          'name' => '/name',
          'created_at' => '/created_at',
          'updated_at' => '/updated_at',
          'identifiers' => [{
            'identifier' => '/wikipedia_id',
            'scheme' => 'Wikipedia',
          }],
          'links' => [{
            'url' => '/opencorporates_url',
            'note' => 'OpenCorporates URL',
          }],
        }

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          parsed_body['corporate_groupings'].map do |data|
            Result.new('ListItem', renderer.result(data['corporate_grouping']), self).finalize!
          end
        end
      end
    end
  end
end
