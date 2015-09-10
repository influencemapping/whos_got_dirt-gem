require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module WhosGotDirt
  RSpec.describe Renderer do
    describe '#initialize' do
      it 'should set the template' do
        expect(Renderer.new('name' => 'John Smith').template).to eq('name' => 'John Smith')
      end
    end

    describe '#result' do
      it 'should render a result' do
        expect(Renderer.new({
          'id' => 123,
          'name' => '/fn',
          'identifiers' => [{
            'identifier' => '/id',
            'scheme' => 'ACME',
          }],
          'delete' => '/blank',
        }).result({
          'id' => 456,
          'fn' => 'John Smith',
          'blank' => nil,
        })).to eq({
          'id' => 123,
          'name' => 'John Smith',
          'identifiers' => [{
            'identifier' => 456,
            'scheme' => 'ACME',
          }],
        })
      end
    end
  end
end
