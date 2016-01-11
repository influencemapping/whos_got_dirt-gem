require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module WhosGotDirt
  RSpec.describe Response do
    let :klass do
      Class.new(Response) do
        class << self
          def name
            'MyResponse'
          end
        end

        @template = {
          '@type' => 'Entity',
          'name' => '/fn',
          'birth_date' => 2015,
          'identifiers' => [{
            'identifier' => '/id',
            'scheme' => 'ACME',
          }]
        }

        def parse_body
          JSON.load(body)
        end

        def to_a
          parsed_body.map do |data|
            Result.new('Entity', renderer.result(data), self).finalize!
          end
        end
      end
    end

    let :body do
      '[{"fn":"John Smith","id":"john-smith"},{"fn":"John Aaron Smith","id":"john-aaron-smith"}]'
    end

    let :response do
      env = Faraday::Env.new
      env.url = 'https://api.example.com/endpoint?name~=John+Smith'
      env.body = body
      Faraday::Response.new(env)
    end

    let :instance do
      klass.new(response)
    end

    let :template do
      {
        '@type' => 'Entity',
        'name' => '/fn',
        'birth_date' => 2015,
        'identifiers' => [{
          'identifier' => '/id',
          'scheme' => 'ACME',
        }]
      }
    end

    let :parsed_body do
      [
        {'fn' => 'John Smith', 'id' => 'john-smith'},
        {'fn' => 'John Aaron Smith', 'id' => 'john-aaron-smith'},
      ]
    end

    describe '.template' do
      it 'should return the template' do
        expect(klass.template).to eq(template)
      end
    end

    describe '#renderer' do
      it 'should return the renderer' do
        expect(instance.renderer.template).to eq(template)
      end
    end

    describe '#parsed_body' do
      it 'should return the parsed response body' do
        expect(instance.parsed_body).to eq(parsed_body)
      end
    end

    describe '#parse_body' do
      it 'should return the parsed response body' do
        expect(instance.parse_body).to eq(parsed_body)
      end
    end

    describe '#to_a' do
      it 'should return the results' do
        expect(instance.to_a).to eq([{
          '@type' => 'Entity',
          'name' => 'John Smith',
          'birth_date' => '2015',
          'identifiers' => [{
            'identifier' => 'john-smith',
            'scheme' => 'ACME',
          }],
          'sources' => [{
            'url' => 'https://api.example.com/endpoint?name~=John+Smith',
            'note' => 'MyResponse',
          }],
        }, {
          '@type' => 'Entity',
          'name' => 'John Aaron Smith',
          'birth_date' => '2015',
          'identifiers' => [{
            'identifier' => 'john-aaron-smith',
            'scheme' => 'ACME',
          }],
          'sources' => [{
            'url' => 'https://api.example.com/endpoint?name~=John+Smith',
            'note' => 'MyResponse',
          }],
        }])
      end
    end

    describe '#error_message' do
      it 'should return the parsed response body' do
        expect(instance.error_message).to eq(body)
      end
    end
  end
end
