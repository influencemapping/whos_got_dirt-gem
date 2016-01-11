module WhosGotDirt
  module Responses
    module Relation
      # Converts concessions from the OpenOil API to Popolo format.
      #
      # @see http://openoil.net/openoil-api/
      class OpenOil < Response
        class << self
          # @private
          def date_formatter(property, path)
            return lambda{|data|
              v = JsonPointer.new(data, path).value
              [property, v.empty? ? nil : v + 'T00:00:00Z']
            }
          end
        end

        @template = {
          '@type' => 'Relation',
          'subject' => lambda{|data|
            v = JsonPointer.new(data, '/licensees').value
            ['subject', v.map{|licensee| {'name' => licensee}}]
          },
          'name' => '/name',
          'identifiers' => [{
            'identifier' => '/identifier',
            'scheme' => 'OpenOil',
          }],
          'links' => [{
            'url' => '/url_api',
            'note' => 'OpenOil API detail',
          }, {
            'url' => '/url_wiki',
            'note' => 'OpenOil wiki page',
          }],
          'sources' => [{
            'url' => '/source_document',
          }],
          'created_at' => date_formatter('created_at', '/source_date'),
          'updated_at' => date_formatter('updated_at', '/retrieved_date'),
          # API-specific.
          'additional_properties' => '/details',
          'country_code' => '/country',
          'status' => '/status',
          'type' => '/type',
        }

        # Parses the response body.
        #
        # @return [Array<Hash>] the parsed response body
        def parse_body
          JSON.load(body)
        end

        # Returns the total number of matching results.
        #
        # @return [Fixnum] the total number of matching results
        def count
          parsed_body['result_count']
        end

        # Returns the current page number.
        #
        # @return [Fixnum] the current page number
        def page
          parsed_body['page']
        end

        # Transforms the parsed response body into results.
        #
        # @return [Array<Hash>] the results
        def to_a
          parsed_body['results'].map do |data|
            Result.new('Relation', renderer.result(data), self).finalize!
          end
        end
      end
    end
  end
end
