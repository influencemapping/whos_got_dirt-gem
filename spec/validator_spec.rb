require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module WhosGotDirt
  RSpec.describe Validator do
    let :invalid do
      {
        'id' => 123,
        'name' => 'John Smith',
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
        'id' => '123',
        'name' => 'John Smith',
        'identifiers' => [{
          'identifier' => 'john-smith',
        }],
      }
    end

    describe '.validate' do
      it 'should return errors for invalid data' do
        expect(Validator.validate(invalid, 'person').map{|error| [error[:fragment], error[:failed_attribute]]}).to eq([
          ['#/id', 'Type'],
          ['#/identifiers/0', 'Properties'],
          ['#/identifiers/2', 'Properties'],
        ])
      end

      it 'should not return errors for valid data' do
        expect(Validator.validate(valid, 'person')).to eq([])
      end
    end
  end
end
