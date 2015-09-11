require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::Person
  RSpec.describe OpenCorporates do
    describe '#to_s' do
      it 'should return the URL to request' do
        expect(OpenCorporates.new(name: 'John Smith').to_s).to eq('https://api.opencorporates.com/officers/search?q=John+Smith&order=score')
      end
    end

    describe '#convert' do
      context 'when given a name' do
        include_examples 'match', 'q', 'name', ['Smith John', 'John Smith']
      end

      context 'when given a birth date' do
        let :strict do
          {
            'birth_date>' => '2010-01-02',
            'birth_date<' => '2010-01-05',
          }
        end

        let :nonstrict do
          strict.merge({
            'birth_date>=' => '2010-01-03',
            'birth_date<=' => '2010-01-04',
          })
        end

        let :exact do
          nonstrict.merge({
            'birth_date' => '2010-01-01',
          })
        end

        it 'should return a criterion' do
          expect(OpenCorporates.new(strict).convert).to eq('date_of_birth' => '2010-01-02:2010-01-05')
        end

        it 'should prioritize or-equal dates' do
          expect(OpenCorporates.new(nonstrict).convert).to eq('date_of_birth' => '2010-01-03:2010-01-04')
        end

        it 'should prioritize exact date' do
          expect(OpenCorporates.new(exact).convert).to eq('date_of_birth' => '2010-01-01:2010-01-01')
        end
      end

      context 'when given a membership' do
        it 'should return a role criterion' do
          expect(OpenCorporates.new('memberships' => [{'role' => 'ceo'}]).convert).to eq('position' => 'ceo')
        end

        it 'should return an inactiv criterion' do
          expect(OpenCorporates.new('memberships' => [{'inactive' => false}]).convert).to eq('inactive' => 'false')
        end

        it 'should not return a criterion' do
          [ ['invalid' => true],
            ['inactive' => 'invalid'],
          ].each do |memberships|
            expect(OpenCorporates.new('memberships' => memberships).convert).to eq({})
          end
        end
      end

      context 'when given a contact detail' do
        it 'should return an address criterion' do
          expect(OpenCorporates.new('contact_details' => [
            {'type' => 'voice', 'value' => '+1-555-555-0100'},
            {'type' => 'address', 'value' => '52 London'},
          ]).convert).to eq('address' => '52 London')
        end

        it 'should not return a criterion' do
          [ [{'invalid' => 'address', 'value' => '52 London'}],
            [{'type' => 'invalid', 'value' => '52 London'}],
            [{'type' => 'address', 'invalid' => '52 London'}],
          ].each do |contact_details|
            expect(OpenCorporates.new('contact_details' => contact_details).convert).to eq({})
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

      context 'when given a jurisdiction' do
        include_examples 'one_of', 'jurisdiction_code', 'jurisdiction_code', ['gb', 'ie']
      end

      context 'when given an API key' do
        it 'should return an API key parameter' do
          expect(OpenCorporates.new('open_corporates_api_key' => 123).convert).to eq('api_token' => 123, 'per_page' => 100)
        end
      end
    end
  end
end
