require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::Entity
  RSpec.describe OpenCorporates do
    describe '#to_s' do
      it 'should return the URL to request' do
        expect(OpenCorporates.new(name: 'ACME Inc.').to_s).to eq('https://api.opencorporates.com/companies/search?q=ACME+Inc.&order=score')
      end
    end

    describe '#convert' do
      context 'when given a name' do
        include_examples 'match', 'q', 'name', ['ACME Inc.', 'Inc. ACME']
      end

      context 'when given a classification' do
        include_examples 'equal', 'company_type', 'classification', 'Private Limited Company'
      end

      context 'when given a creation timestamp' do
        include_examples 'equal', 'created_since', 'created_at>=', '2010-01-01'
      end

      context 'when given a founding date' do
        include_examples 'date_range', 'incorporation_date', 'founding_date'
      end

      context 'when given a founding date' do
        include_examples 'date_range', 'dissolution_date', 'dissolution_date'
      end

      context 'when given a contact detail' do
        include_examples 'contact_details', 'registered_address', 'address', ['52 London', 'London 52']
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

      context 'when given a country' do
        include_examples 'one_of', 'country_code', 'country_code', ['GB', 'IE'], '|', transformed: ['gb', 'ie']
      end

      context 'when given a status' do
        include_examples 'equal', 'current_status', 'current_status', 'Dissolved'
      end

      context 'when given an industry' do
        include_examples 'one_of', 'industry_codes', 'industry_code', ['be_nace_2008-66191', 'be_nace_2008-66199'], '|'
      end

      context 'when given an inactivity status' do
        include_examples 'equal', 'inactive', 'inactive', true, valid: [true, false]
      end

      context 'when given a branch status' do
        include_examples 'equal', 'branch', 'branch', true, valid: [true, false]
      end

      context 'when given a nonprofit status' do
        include_examples 'equal', 'nonprofit', 'nonprofit', true, valid: [true, false]
      end
    end
  end
end
