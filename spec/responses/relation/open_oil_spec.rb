require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Responses::Relation
  RSpec.describe OpenOil, vcr: {cassette_name: 'open_oil_relation'} do
    let :response do
      Faraday.get("https://api.openoil.net/concession/search?apikey=#{ENV['OPEN_OIL_API_KEY']}")
    end

    let :instance do
      OpenOil.new(response)
    end

    describe '#to_a' do
      it 'should return the results' do
        expect{instance.to_a}.to_not raise_error
      end
    end

    describe '#count' do
      it 'should return the number of results' do
        expect(instance.count).to be > 10_000
      end
    end

    describe '#page' do
      it 'should return the current page number' do
        expect(instance.page).to eq(1)
      end
    end
  end
end
