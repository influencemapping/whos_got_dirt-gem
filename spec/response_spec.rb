require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module WhosGotDirt
  RSpec.describe Response do
    let :klass do
      Class.new(Response) do
        @template = {
          'id' => 123,
          'name' => '$.fn',
          'identifiers' => [{
            'identifier' => '$.id',
            'scheme' => 'ACME',
          }]
        }

        def parse_body
          JSON.load(body)
        end

        def to_a
          parsed_body.map do |data|
            add_source(renderer.result(data))
          end
        end
      end
    end

    let :response do
      env = Faraday::Env.new
      env.url = 'https://api.example.com/endpoint?name~=John+Smith'
      env.body = '[{"fn":"John Smith","id":"john-smith"},{"fn":"John Aaron Smith","id":"john-aaron-smith"}]'
      Faraday::Response.new(env)
    end

    let :instance do
      klass.new(response)
    end

    let :template do
      {
        'id' => 123,
        'name' => '$.fn',
        'identifiers' => [{
          'identifier' => '$.id',
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

    describe '#initialize' do
      it 'should set the renderer and parsed body' do
        expect(instance.renderer.template).to eq(template)
        expect(instance.parsed_body).to eq(parsed_body)
      end
    end

    describe '.template' do
      it 'should return the template' do
        expect(klass.template).to eq(template)
      end
    end

    describe '#template' do
      it 'should return the template' do
        expect(instance.template).to eq(template)
      end
    end

    describe '#parse_body' do
      it 'should return the parsed response body' do
        expect(instance.parse_body).to eq(parsed_body)
      end
    end

    describe '#to_a' do
      it 'should return the results' do
        expect(klass.new(response).to_a).to eq([{
          'id' => 123,
          'name' => 'John Smith',
          'identifiers' => [{
            'identifier' => 'john-smith',
            'scheme' => 'ACME',
          }],
          'sources' => [{
            'url' => 'https://api.example.com/endpoint?name~=John+Smith',
            'note' => nil,
          }],
        }, {
          'id' => 123,
          'name' => 'John Aaron Smith',
          'identifiers' => [{
            'identifier' => 'john-aaron-smith',
            'scheme' => 'ACME',
          }],
          'sources' => [{
            'url' => 'https://api.example.com/endpoint?name~=John+Smith',
            'note' => nil,
          }],
        }])
      end
    end

    describe '#add_source' do
      it 'should add a source to a result' do
        expect(instance.add_source({})).to eq('sources' => [{
          'url' => 'https://api.example.com/endpoint?name~=John+Smith',
          'note' => nil,
        }])
      end
    end
  end
end
