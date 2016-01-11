module WhosGotDirt
  module Responses
    module List
      # Converts corporate groupings from the OpenCorporates API to Popolo format.
      #
      # @see https://api.opencorporates.com/documentation/API-Reference
      class OpenCorporates < Helpers::OpenCorporatesHelper
        @template = {
          '@type' => 'List',
          'name' => '/name',
          'identifiers' => [{
            'identifier' => '/wikipedia_id',
            'scheme' => 'Wikipedia',
          }],
          'links' => [{
            'url' => '/opencorporates_url',
            'note' => 'OpenCorporates page',
          }],
          'created_at' => '/created_at',
          'updated_at' => '/updated_at',
        }

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          parsed_body['corporate_groupings'].map do |data|
            Result.new('List', renderer.result(data['corporate_grouping']), self).finalize!
          end
        end
      end
    end
  end
end
