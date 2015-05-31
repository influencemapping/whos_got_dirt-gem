require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module WhosGotDirt
  RSpec.describe Response do
    let :klass do
      Class.new(Response) do
        def to_a
          JSON.load(body).map do |result|
            {
              request_url: env.url.to_s,
              name: result['Name'],
            }
          end
        end
      end
    end

    let :response do
      env = Faraday::Env.new
      env.url = 'https://api.example.com/endpoint?name~=John+Smith'
      env.body = '[{"Name":"John Smith"},{"Name":"John Aaron Smith"}]'
      Faraday::Response.new(env)
    end

    describe '#to_a' do
      it 'should return the results' do
        expect(klass.new(response).to_a).to eq([{
          request_url: 'https://api.example.com/endpoint?name~=John+Smith',
          name: 'John Smith',
        }, {
          request_url: 'https://api.example.com/endpoint?name~=John+Smith',
          name: 'John Aaron Smith',
        }])
      end
    end
  end
end
