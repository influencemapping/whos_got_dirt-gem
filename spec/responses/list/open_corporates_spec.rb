require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Responses::List
  RSpec.describe OpenCorporates, vcr: {cassette_name: 'open_corporates_list'} do
    let :response do
      Faraday.get('https://api.opencorporates.com/corporate_groupings/search')
    end

    let :instance do
      OpenCorporates.new(response)
    end

    describe '#to_a' do
      it 'should return the results' do
        expect{instance}.to_not raise_error
      end
    end

    describe '#count' do
      it 'should return the number of results' do
        expect(instance.count).to be > 800
      end
    end

    describe '#page' do
      it 'should return the current page number' do
        expect(instance.page).to eq(1)
      end
    end
  end
end
