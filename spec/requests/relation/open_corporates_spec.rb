require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::Relation
  RSpec.describe OpenCorporates do
    describe '#to_s' do
      it 'should return the URL to request' do
        expect(OpenCorporates.new(subject: [name: 'John Smith']).to_s).to eq('https://api.opencorporates.com/officers/search?q=John+Smith&order=score')
      end
    end

    describe '#convert' do
      context 'when given a name' do
        include_examples 'match', 'q', 'name', ['Smith John', 'John Smith'], scope: 'subject'
      end

      context 'when given a birth date' do
        include_examples 'date_range', 'date_of_birth', 'birth_date', scope: 'subject'
      end

      context 'when given a contact detail' do
        include_examples 'contact_details', 'address', 'address', ['52 London', 'London 52'], scope: 'subject'
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

      context 'when given a jurisdiction' do
        include_examples 'one_of', 'jurisdiction_code', 'jurisdiction_code', ['GB', 'IE'], '|', transformed: ['gb', 'ie']
      end

      context 'when given a role' do
        include_examples 'equal', 'position', 'role', 'ceo'
      end

      context 'when given an inactivity status' do
        include_examples 'equal', 'inactive', 'inactive', false, valid: [true, false]
      end
    end
  end
end
