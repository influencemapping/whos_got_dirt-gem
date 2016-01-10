require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Responses::List
  RSpec.describe LittleSis do
    context 'when successful', vcr: {cassette_name: 'little_sis_list'} do
      let :response do
        Faraday.get("https://api.littlesis.org/lists.xml?q=united&_key=#{ENV['LITTLE_SIS_API_KEY']}")
      end

      let :instance do
        LittleSis.new(response)
      end

      describe '#to_a' do
        it 'should return the results' do
          expect{instance.to_a}.to_not raise_error
        end
      end

      describe '#count' do
        it 'should return the number of results' do
          expect(instance.count).to be > 10
        end
      end

      describe '#page' do
        it 'should return the current page number' do
          expect(instance.page).to eq(1)
        end
      end
    end

    context 'when unsuccessful', vcr: {cassette_name: 'little_sis_list_error'} do
      let :response do
        Faraday.get("https://api.littlesis.org/lists.xml?q=united")
      end

      let :instance do
        LittleSis.new(response)
      end

      describe '#error_message' do
        it 'should return the error message' do
         expect(instance.error_message).to eq('Your request must include a query parameter named "_key" with a valid API key value. To obtain an API key, visit http://api.littlesis.org/register.')
       end
      end
    end
  end
end
