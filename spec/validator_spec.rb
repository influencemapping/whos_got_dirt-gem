require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module WhosGotDirt
  RSpec.describe Validator do
    let :invalid do
      {
        'name' => 'John Smith',
        'birth_date' => 2015,
        'identifiers' => [{
          'scheme' => 'ACME',
        }, {
          'identifier' => 'john-smith',
        }, {
          'scheme' => 'ACME',
        }],
      }
    end

    let :valid do
      {
        'name' => 'John Smith',
        'birth_date' => '2015',
        'identifiers' => [{
          'identifier' => 'john-smith',
        }],
      }
    end

    describe '.validate' do
      it 'should return errors for invalid data' do
        expect(Validator.validate(invalid, 'entity').map{|error| [error[:fragment], error[:failed_attribute]]}).to eq([
          ['#/birth_date', 'Type'],
          ['#/identifiers/0', 'Properties'],
          ['#/identifiers/2', 'Properties'],
        ])
      end

      it 'should not return errors for valid data' do
        expect(Validator.validate(valid, 'entity')).to eq([])
      end
    end
  end
end
