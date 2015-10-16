require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::Relation
  RSpec.describe OpenCorporates do
    describe '#to_s' do
      it 'should return the URL to request' do
        expect(OpenCorporates.new(subject: [name: 'John Smith']).to_s).to eq('https://api.opencorporates.com/officers/search?q=John+Smith&order=score')
      end
    end

    describe '#convert' do
      context 'when given a role' do
        include_examples 'equal', 'position', 'role', 'ceo'
      end

      context 'when given a name' do
        include_examples 'match', 'q', 'name', ['Smith John', 'John Smith'], scope: 'subject'
      end

      context 'when given a birth date' do
        include_examples 'date_range', 'date_of_birth', 'birth_date', scope: 'subject'
      end

      context 'when given a contact detail' do
        let :fuzzy do
          [
            {'type' => 'voice', 'value' => '+1-555-555-0100'},
            {'type' => 'address', 'value~=' => '52 London'},
          ]
        end

        let :exact do
          fuzzy << {'type' => 'address', 'value' => 'London 52'}
        end

        it 'should return a criterion' do
          expect(OpenCorporates.new('subject' => ['contact_details' => fuzzy]).convert).to eq('address' => '52 London')
        end

        it 'should prioritize exact value' do
          expect(OpenCorporates.new('subject' => ['contact_details' => exact]).convert).to eq('address' => 'London 52')
        end

        it 'should not return a criterion' do
          [ [{'invalid' => 'address', 'value' => '52 London'}],
            [{'type' => 'invalid', 'value' => '52 London'}],
            [{'type' => 'address', 'invalid' => '52 London'}],
          ].each do |contact_details|
            expect(OpenCorporates.new('subject' => ['contact_details' => contact_details]).convert).to eq({})
          end
        end
      end

      context 'when given a limit' do
        it 'should return a per-page limit' do
          expect(OpenCorporates.new('limit' => 5).convert).to eq('per_page' => 5)
        end

        it 'should override the default authenticated per-page limit' do
          expect(OpenCorporates.new('limit' => 5, 'open_corporates_api_key' => 123).convert).to eq('per_page' => 5, 'api_token' => 123)
        end
      end

      context 'when given an API key' do
        it 'should return an API key parameter' do
          expect(OpenCorporates.new('open_corporates_api_key' => 123).convert).to eq('api_token' => 123, 'per_page' => 100)
        end
      end

      context 'when given a jurisdiction' do
        include_examples 'one_of', 'jurisdiction_code', 'jurisdiction_code', ['gb', 'ie']
      end

      context 'when given an inactivity status' do
        include_examples 'equal', 'inactive', 'inactive', false, valid: [true, false]
      end
    end
  end
end
