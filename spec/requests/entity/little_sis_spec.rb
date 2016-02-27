require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::Entity
  RSpec.describe LittleSis do
    describe '#to_s' do
      it 'should return the URL to request' do
        expect(LittleSis.new(name: 'ACME Inc.').to_s).to eq('https://api.littlesis.org/entities.xml?q=ACME+Inc.')
      end
    end

    describe '#convert' do
      context 'when given a name' do
        include_examples 'match', 'q', 'name', ['ACME Inc.', 'Inc. ACME']
      end

      context 'when given a classification' do
        include_examples 'one_of', 'type_ids', 'classification', [1, 2], ','
      end

      context 'when given a limit' do
        include_examples 'equal', 'num', 'limit', 5
      end

      context 'when given a page' do
        include_examples 'equal', 'page', 'page', 2
      end

      context 'when given an API key' do
        include_examples 'equal', '_key', 'little_sis_api_key', 123
      end

      context 'when given a "search all" flag' do
        include_examples 'equal', 'search_all', 'search_all', 1, valid: [1]
      end
    end
  end
end
