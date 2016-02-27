require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::Relation
  RSpec.describe OpenOil do
    describe '#to_s' do
      it 'should return the URL to request' do
        expect(OpenOil.new(subject: [name: 'Petrobras']).to_s).to eq('https://api.openoil.net/concession/search?licensee=Petrobras')
      end
    end

    describe '#convert' do
      context 'when given a name' do
        include_examples 'equal', 'licensee', 'name', 'Petrobras', scope: 'subject'
      end

      context 'when given a limit' do
        include_examples 'equal', 'per_page', 'limit', 5
      end

      context 'when given a page' do
        include_examples 'equal', 'page', 'page', 2
      end

      context 'when given an API key' do
        include_examples 'equal', 'apikey', 'open_oil_api_key', 123
      end

      context 'when given a country' do
        include_examples 'equal', 'country', 'country_code', 'br', transformed: 'BR'
      end

      context 'when given a status' do
        include_examples 'equal', 'status', 'status', 'licensed', valid: ['licensed', 'unlicensed']
      end

      context 'when given a type' do
        include_examples 'equal', 'type', 'type', 'offshore', valid: ['offshore', 'onshore']
      end
    end
  end
end
