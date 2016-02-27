require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::List
  RSpec.describe LittleSis do
    describe '#to_s' do
      it 'should return the URL to request' do
        expect(LittleSis.new(name: 'forbes').to_s).to eq('https://api.littlesis.org/lists.xml?q=forbes')
      end
    end

    describe '#convert' do
      context 'when given a name' do
        include_examples 'match', 'q', 'name', ['forbes', 'forbe']
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
    end
  end
end
