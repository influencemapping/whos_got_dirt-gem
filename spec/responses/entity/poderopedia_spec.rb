require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Responses::Entity
  RSpec.describe Poderopedia, vcr: {cassette_name: 'poderopedia_entity'} do
    let :response do
      Faraday.get("http://api.poderopedia.org/visualizacion/search?alias=juan&entity=persona&user_key=#{ENV['PODEROPEDIA_API_KEY']}")
    end

    let :instance do
      Poderopedia.new(response)
    end

    describe '#to_a' do
      it 'should return the results' do
        expect{instance.to_a}.to_not raise_error
      end
    end

    describe '#count' do
      it 'should return the number of results' do
        expect(instance.count).to eq(10)
      end
    end
  end
end
