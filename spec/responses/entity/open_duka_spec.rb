require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Responses::Entity
  RSpec.describe OpenDuka, vcr: {cassette_name: 'open_duka_entity'} do
    let :response do
      Faraday.get("http://www.openduka.org/index.php/api/search?term=the&key=#{ENV['OPEN_DUKA_API_KEY']}")
    end

    let :instance do
      OpenDuka.new(response)
    end

    describe '#to_a' do
      it 'should return the results' do
        expect{instance.to_a}.to_not raise_error
      end
    end

    describe '#count' do
      it 'should return the number of results' do
        expect(instance.count).to be > 1_000
      end
    end
  end
end
