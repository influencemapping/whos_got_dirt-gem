require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Responses::Entity
  RSpec.describe CorpWatch, vcr: {cassette_name: 'corp_watch_entity'} do
    let :response do
      Faraday.get("http://api.corpwatch.org/companies.json?company_name=bank&key=#{ENV['CORP_WATCH_API_KEY']}")
    end

    let :instance do
      CorpWatch.new(response)
    end

    describe '#to_a' do
      it 'should return the results' do
        expect{instance.to_a}.to_not raise_error
      end
    end

    describe '#count' do
      it 'should return the number of results' do
        expect(instance.count).to be > 3_000
      end
    end

    describe '#index' do
      it 'should return the current index' do
        expect(instance.index).to eq(0)
      end
    end
  end
end
