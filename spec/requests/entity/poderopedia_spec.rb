require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::Entity
  RSpec.describe Poderopedia do
    describe '#to_s' do
      it 'should return the URL to request' do
        expect(Poderopedia.new(name: 'ACME Inc.').to_s).to eq('http://api.poderopedia.org/visualizacion/search?alias=ACME+Inc.')
      end
    end

    describe '#convert' do
      context 'when given a name' do
        include_examples 'match', 'alias', 'name', ['ACME Inc.', 'Inc. ACME']
      end

      context 'when given an API key' do
        include_examples 'equal', 'user_key', 'poderopedia_api_key', 123
      end
    end
  end
end
