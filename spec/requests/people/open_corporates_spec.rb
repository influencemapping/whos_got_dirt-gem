require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module WhosGotDirt::Requests::People
  RSpec.describe OpenCorporates do
    describe '#convert' do
      context 'when given a jurisdiction' do
        let :many do
          {
            'jurisdiction_code|=' => ['gb', 'ie'],
          }
        end

        let :one do
          many.merge({
            'jurisdiction_code' => 'gb'
          })
        end

        it 'should return a criterion' do
          expect(OpenCorporates.convert(many)).to eq('jurisdiction_code' => 'gb|ie')
        end

        it 'should prioritize exact jurisdiction' do
          expect(OpenCorporates.convert(one)).to eq('jurisdiction_code' => 'gb')
        end
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
          expect(OpenCorporates.convert(strict)).to eq('date_of_birth' => '2010-01-02:2010-01-05')
        end

        it 'should prioritize or-equal dates' do
          expect(OpenCorporates.convert(nonstrict)).to eq('date_of_birth' => '2010-01-03:2010-01-04')
        end

        it 'should prioritize exact date' do
          expect(OpenCorporates.convert(exact)).to eq('date_of_birth' => '2010-01-01:2010-01-01')
        end
      end

      context 'when given a membership' do
        it 'should return a role criterion' do
          expect(OpenCorporates.convert('memberships' => ['role' => 'ceo'])).to eq('position' => 'ceo')
        end

        it 'should return a status criterion' do
          expect(OpenCorporates.convert('memberships' => ['status' => 'active'])).to eq('inactive' => 'false')
        end

        it 'should not return a criterion' do
          [ [],
            ['invalid' => 'foo'],
            ['status' => 'invalid'],
          ].each do |memberships|
            expect(OpenCorporates.convert('memberships' => memberships)).to eq({})
          end
        end
      end

      context 'when given a contact detail' do
        it 'should return an address criterion' do
          expect(OpenCorporates.convert('contact_details' => ['type' => 'address', 'value' => 'foo'])).to eq('address' => 'foo')
        end

        it 'should not return a criterion' do
          [ [],
            ['invalid' => 'address', 'value' => 'foo'],
            ['type' => 'invalid', 'value' => 'foo'],
            ['type' => 'address', 'invalid' => 'foo'],
          ].each do |contact_details|
            expect(OpenCorporates.convert('contact_details' => contact_details)).to eq({})
          end
        end
      end

      context 'when given an API key' do
        it 'should return an API key parameter' do
          expect(OpenCorporates.convert('open_corporates_api_key' => 123)).to eq('api_token' => 123, 'per_page' => 100)
        end
      end
    end
  end
end
