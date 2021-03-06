require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::List
  RSpec.describe OpenCorporates do
    describe '#to_s' do
      it 'should return the URL to request' do
        expect(OpenCorporates.new(name: 'barclays').to_s).to eq('https://api.opencorporates.com/corporate_groupings/search?q=barclays')
      end
    end

    describe '#convert' do
      context 'when given a name' do
        include_examples 'match', 'q', 'name', ['barclays', 'bayclay']
      end

      context 'when given a limit' do
        it 'should return a per-page limit' do
          expect(OpenCorporates.new('limit' => 5).convert).to eq('per_page' => 5)
        end

        it 'should override the default authenticated per-page limit' do
          expect(OpenCorporates.new('limit' => 5, 'open_corporates_api_key' => 123).convert).to eq('per_page' => 5, 'api_token' => 123)
        end
      end

      context 'when given a page' do
        include_examples 'equal', 'page', 'page', 2
      end

      context 'when given an API key' do
        it 'should return an API key parameter' do
          expect(OpenCorporates.new('open_corporates_api_key' => 123).convert).to eq('api_token' => 123, 'per_page' => 100)
        end
      end
    end
  end
end
