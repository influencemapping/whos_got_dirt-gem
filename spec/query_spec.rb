require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module WhosGotDirt
  RSpec.describe Query do
    let :klass do
      Class.new(Query) do
        @base_url = 'http://example.com'

        def to_s
          "#{base_url}?#{to_query(params.merge(query: q))}"
        end
      end
    end

    let :instance do
      klass.new('foo', bar: false, baz: nil)
    end

    describe '.to_query' do
      it 'should return a query string' do
        expect(klass.to_query(foo: '/', bar: false, baz: nil)).to eq('foo=%2F&bar=false&baz=')
      end
    end

    describe '#initialize' do
      it 'should set the query and parameters' do
        expect(instance.q).to eq('foo')
        expect(instance.params).to eq('bar' => false, 'baz' => nil)
      end

      it 'should accept no arguments' do
        expect{klass.new}.to_not raise_error
      end
    end

    describe '.base_url' do
      it 'should return the base url' do
        expect(klass.base_url).to eq('http://example.com')
      end
    end

    describe '#base_url' do
      it 'should return the base url' do
        expect(klass.new.base_url).to eq('http://example.com')
      end
    end

    describe '#to_s' do
      it 'should return the query as a string' do
        expect(instance.to_s).to eq('http://example.com?bar=false&baz=&query=foo')
      end
    end
  end
end
