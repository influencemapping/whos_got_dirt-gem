require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Responses::Entity
  RSpec.describe LittleSis, vcr: {cassette_name: 'little_sis_entity'} do
    let :response do
      Faraday.get("https://api.littlesis.org/entities.xml?q=bar&_key=#{ENV['LITTLE_SIS_API_KEY']}")
    end

    let :instance do
      LittleSis.new(response)
    end

    describe '#to_a' do
      it 'should return the results' do
        expect{instance}.to_not raise_error
      end
    end

    describe '#count' do
      it 'should return the number of results' do
        expect(instance.count).to be > 1_000
      end
    end

    describe '#page' do
      it 'should return the current page number' do
        expect(instance.page).to eq(1)
      end
    end
  end
end
