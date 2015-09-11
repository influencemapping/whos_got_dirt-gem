require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module WhosGotDirt
  RSpec.describe Result do
    let :result do
      {
        'id' => 123,
        'name' => 'John Smith',
        'identifiers' => [{
          'scheme' => 'ACME',
        }, {
          'identifier' => 'john-smith',
        }, {
          'scheme' => 'ACME',
        }],
      }
    end

    let :response do
      env = Faraday::Env.new
      env.url = 'https://api.example.com/endpoint?name~=John+Smith'
      env.body = '[{"fn":"John Smith","id":"john-smith"},{"fn":"John Aaron Smith","id":"john-aaron-smith"}]'
      Faraday::Response.new(env)
    end

    let :instance do
      Result.new(result, response, 'person')
    end

    describe '#initialize' do
      it 'should set the result, response and schema' do
        expect(instance.result).to eq(result)
        expect(instance.response).to eq(response)
        expect(instance.schema).to eq('person')
      end
    end

    describe '#add_source!' do
      it 'should add a source to a result' do
        expect(instance.add_source!).to eq({
          'id' => 123,
          'name' => 'John Smith',
          'identifiers' => [{
            'scheme' => 'ACME',
          }, {
            'identifier' => 'john-smith',
          }, {
            'scheme' => 'ACME',
          }],
          'sources' => [{
            'url' => 'https://api.example.com/endpoint?name~=John+Smith',
            'note' => 'Response',
          }],
        })
      end
    end

    describe 'validate!' do
      it 'should validate the result' do
        expect(instance.validate!).to eq({
          'id' => '123',
          'name' => 'John Smith',
          'identifiers' => [{
            'identifier' => 'john-smith',
          }],
        })
      end

      it 'should raise an error if validation is strict' do
        expect{instance.validate!(strict: true)}.to raise_error(ValidationError)
      end
    end

    describe '#finalize!' do
      it 'should finalize the result' do
        expect(instance.finalize!).to eq({
          'id' => '123',
          'name' => 'John Smith',
          'identifiers' => [{
            'identifier' => 'john-smith',
          }],
          'sources' => [{
            'url' => 'https://api.example.com/endpoint?name~=John+Smith',
            'note' => 'Response',
          }],
        })
      end
    end
  end
end
