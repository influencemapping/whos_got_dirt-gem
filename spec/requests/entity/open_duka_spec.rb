require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::Entity
  RSpec.describe OpenDuka do
    describe '#to_s' do
      it 'should return the URL to request' do
        expect(OpenDuka.new(name: 'ACME Inc.').to_s).to eq('http://www.openduka.org/index.php/api/search?term=ACME+Inc.')
      end
    end

    describe '#convert' do
      context 'when given a name' do
        include_examples 'match', 'term', 'name', ['ACME Inc.', 'Inc. ACME']
      end

      context 'when given an API key' do
        include_examples 'equal', 'key', 'open_duka_api_key', 123
      end
    end
  end
end
