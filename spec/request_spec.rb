require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module WhosGotDirt
  RSpec.describe Request do
    let :klass do
      Class.new(Request) do
        @base_url = 'https://api.example.com/endpoint'

        def to_s
          "#{base_url}?#{to_query(input)}"
        end
      end
    end

    let :instance do
      klass.new(q: 'foo', bar: false, baz: nil)
    end

    describe '.to_query' do
      it 'should return a query string' do
        expect(klass.to_query(foo: '/', bar: false, baz: nil)).to eq('foo=%2F&bar=false&baz=')
      end
    end

    describe '#initialize' do
      it 'should set the query and parameters' do
        expect(instance.input).to eq('q' => 'foo', 'bar' => false, 'baz' => nil)
      end

      it 'should accept no arguments' do
        expect{klass.new}.to_not raise_error
      end
    end

    describe '.base_url' do
      it 'should return the base URL' do
        expect(klass.base_url).to eq('https://api.example.com/endpoint')
      end
    end

    describe '#base_url' do
      it 'should return the base URL' do
        expect(instance.base_url).to eq('https://api.example.com/endpoint')
      end
    end

    describe '#equal' do
      let :fuzzy do
        {
          'source~=' => 'Smith John',
        }
      end

      let :exact do
        fuzzy.merge({
          'source' => 'John Smith'
        })
      end

      it 'should return a criterion' do
        expect(klass.new(fuzzy).equal('target', 'source', 'source~=')).to eq('target' => 'Smith John')
      end

      it 'should prioritize exact match' do
        expect(klass.new(exact).equal('target', 'source', 'source~=')).to eq('target' => 'John Smith')
      end
    end

    describe '#one_of' do
      let :many do
        {
          'source|=' => ['one', 'two'],
        }
      end

      let :one do
        many.merge({
          'source' => 'three'
        })
      end

      it 'should return a criterion' do
        expect(klass.new(many).one_of('target', 'source')).to eq('target' => 'one|two')
      end

      it 'should prioritize exact match' do
        expect(klass.new(one).one_of('target', 'source')).to eq('target' => 'three')
      end
    end

    describe '#to_s' do
      it 'should return the query as a string' do
        expect(instance.to_s).to eq('https://api.example.com/endpoint?q=foo&bar=false&baz=')
      end
    end
  end
end
