require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::Entity
  RSpec.describe CorpWatch do
    describe '#to_s' do
      it 'should return the URL to request' do
        expect(CorpWatch.new(name: 'ACME Inc.').to_s).to eq('http://api.corpwatch.org/companies.json?company_name=ACME+Inc.')
      end
    end

    describe '#convert' do
      context 'when given a name' do
        include_examples 'match', 'company_name', 'name', ['ACME Inc.', 'Inc. ACME']
      end

      context 'when given a limit' do
        include_examples 'equal', 'limit', 'limit', 5
      end

      context 'when given an IRS identifier' do
        it 'should return a criterion' do
          expect(CorpWatch.new({
            'identifiers' => [{
              'identifier' => '911653725',
              'scheme' => 'IRS Employer Identification Number',
            }],
          }).convert).to eq('irs_number' => '911653725')
        end
      end

      context 'when given an SEC identifier' do
        it 'should return a criterion' do
          expect(CorpWatch.new({
            'identifiers' => [{
              'identifier' => '37996',
              'scheme' => 'SEC Central Index Key',
            }],
          }).convert).to eq('cik' => '37996')
        end
      end

      context 'when given a contact detail' do
        include_examples 'contact_details', 'raw_address', 'address', ['52 London', 'London 52']
      end

      context 'when given an API key' do
        include_examples 'equal', 'key', 'corp_watch_api_key', 123
      end

      context 'when given an industry code' do
        include_examples 'equal', 'sic_code', 'industry_code', '2011'
      end

      context 'when given a sector code' do
        include_examples 'equal', 'sic_sector', 'sector_code', '4100'
      end

      context 'when given a "substring_match all" flag' do
        include_examples 'equal', 'substring_match', 'substring_match', 1, valid: [1]
      end

      context 'when given a country code' do
        include_examples 'equal', 'country_code', 'country_code', 'us', transformed: 'US'
      end

      context 'when given a country subdivision code' do
        include_examples 'equal', 'subdiv_code', 'subdiv_code', 'or', transformed: 'OR'
      end

      context 'when given a year' do
        include_examples 'equal', 'year', 'year', '2005'
      end

      context 'when given a minimum year' do
        include_examples 'equal', 'min_year', 'year>=', '2003'
      end

      context 'when given a maximum year' do
        include_examples 'equal', 'max_year', 'year<=', '2007'
      end

      context 'when given a source type' do
        include_examples 'equal', 'source_type', 'source_type', 'filers'
      end

      context 'when given a number of children' do
        include_examples 'equal', 'num_children', 'num_children', 3
      end

      context 'when given a number of parents' do
        include_examples 'equal', 'num_parents', 'num_parents', 2
      end

      context 'when given a root company identifier' do
        include_examples 'equal', 'top_parent_id', 'top_parent_id', 'cw_7324'
      end
    end
  end
end
