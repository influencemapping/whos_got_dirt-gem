require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module WhosGotDirt
  RSpec.describe Request do
    let :klass do
      Class.new(Request) do
        @base_url = 'https://api.example.com/endpoint'

        def to_s
          "#{base_url}?#{to_query(input)}"
        end

        def or_operator
          '|'
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
      it 'should return a criterion' do
        expect(klass.new('source' => 'John Smith').equal('target', 'source')).to eq('target' => 'John Smith')
      end

      it 'should return a criterion when input is overridden' do
        expect(klass.new(nil).equal('target', 'source', input: {'source' => 'John Smith'})).to eq('target' => 'John Smith')
      end

      it 'should return a criterion when value is transformed' do
        expect(klass.new('source' => 'John Smith').equal('target', 'source', transform: lambda{|v| v.upcase})).to eq('target' => 'JOHN SMITH')
      end

      it 'should accept valid values' do
        expect(klass.new('source' => true).equal('target', 'source', valid: [true, false])).to eq('target' => true)
      end

      it 'should ignore invalid values' do
        expect(klass.new('source' => 'John Smith').equal('target', 'source', valid: [true, false])).to eq({})
      end
    end

    describe '#match' do
      let :fuzzy do
        {'source~=' => 'Smith John'}
      end

      let :exact do
        fuzzy.merge('source' => 'John Smith')
      end

      it 'should return a criterion' do
        expect(klass.new(fuzzy).match('target', 'source')).to eq('target' => 'Smith John')
      end

      it 'should return a criterion when input is overridden' do
        expect(klass.new(nil).match('target', 'source', input: fuzzy)).to eq('target' => 'Smith John')
      end

      it 'should return a criterion when value is transformed' do
        expect(klass.new(fuzzy).match('target', 'source', transform: lambda{|v| v.upcase})).to eq('target' => 'SMITH JOHN')
        expect(klass.new(exact).match('target', 'source', transform: lambda{|v| v.upcase})).to eq('target' => 'JOHN SMITH')
      end

      it 'should prioritize exact match' do
        expect(klass.new(exact).match('target', 'source')).to eq('target' => 'John Smith')
      end
    end

    describe '#one_of' do
      let :many do
        {'source|=' => ['one', 'two']}
      end

      let :one do
        many.merge('source' => 'three')
      end

      it 'should return a criterion' do
        expect(klass.new(many).one_of('target', 'source')).to eq('target' => 'one|two')
      end

      it 'should return a criterion when input is overridden' do
        expect(klass.new(nil).one_of('target', 'source', input: many)).to eq('target' => 'one|two')
      end

      it 'should return a criterion when values are transformed' do
        expect(klass.new(many).one_of('target', 'source', transform: lambda{|v| v.upcase})).to eq('target' => 'ONE|TWO')
        expect(klass.new(one).one_of('target', 'source', transform: lambda{|v| v.upcase})).to eq('target' => 'THREE')
      end

      it 'should prioritize exact match' do
        expect(klass.new(one).one_of('target', 'source')).to eq('target' => 'three')
      end
    end

    describe '#date_range' do
      let :strict do
        {
          'source>' => '2010-01-02',
          'source<' => '2010-01-05',
        }
      end

      let :nonstrict do
        strict.merge({
          'source>=' => '2010-01-03',
          'source<=' => '2010-01-04',
        })
      end

      let :exact do
        nonstrict.merge({
          'source' => '2010-01-01',
        })
      end

      it 'should return a criterion' do
        expect(klass.new(strict).date_range('target', 'source')).to eq('target' => '2010-01-02:2010-01-05')
      end

      it 'should return a criterion when input is overridden' do
        expect(klass.new(nil).date_range('target', 'source', input: strict)).to eq('target' => '2010-01-02:2010-01-05')
      end

      it 'should prioritize or-equal dates' do
        expect(klass.new(nonstrict).date_range('target', 'source')).to eq('target' => '2010-01-03:2010-01-04')
      end

      it 'should prioritize exact date' do
        expect(klass.new(exact).date_range('target', 'source')).to eq('target' => '2010-01-01:2010-01-01')
      end
    end

    describe '#to_s' do
      it 'should return the query as a string' do
        expect(instance.to_s).to eq('https://api.example.com/endpoint?q=foo&bar=false&baz=')
      end
    end
  end
end
