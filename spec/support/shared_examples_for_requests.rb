def input(variable, options)
  if options && options.key?(:scope)
    {options[:scope] => [variable]}
  else
     variable
  end
end

def transform(value, options)
  if options && options.key?(:transformed)
    options[:transformed]
  else
    value
  end
end

RSpec.shared_examples 'equal' do |target,source,value,options|
  it 'should return a criterion' do
    expect(described_class.new(input({source => value}, options)).convert).to eq(target => transform(value, options))
  end

  if options && options.key?(:valid)
    it 'should accept valid values' do
      options[:valid].each do |value|
        expect(described_class.new(input({source => value}, options)).convert).to eq(target => transform(value, options))
      end
    end

    it 'should ignore invalid values' do
      expect(described_class.new(input({source => 'invalid'}, options)).convert).to eq({})
    end
  end
end

RSpec.shared_examples 'match' do |target,source,values,options|
  let :fuzzy do
    {"#{source}~=" => values.first}
  end

  let :exact do
    fuzzy.merge(source => values.last)
  end

  it 'should return a criterion' do
    expect(described_class.new(input(fuzzy, options)).convert).to eq('q' => values.first)
  end

  it 'should prioritize exact value' do
    expect(described_class.new(input(exact, options)).convert).to eq('q' => values.last)
  end
end

RSpec.shared_examples 'one_of' do |target,source,values,options|
  let :many do
    {"#{source}|=" => values}
  end

  let :one do
    many.merge(source => values.first)
  end

  let :all do
    many.merge(source => values)
  end

  it 'should return a criterion' do
    expect(described_class.new(input(many, options)).convert).to eq(target => values.join('|'))
  end

  it 'should prioritize exact match' do
    expect(described_class.new(input(one, options)).convert).to eq(target => values.first)
  end

  it 'should prioritize all match' do
    expect(described_class.new(input(all, options)).convert).to eq(target => values.join(','))
  end
end

RSpec.shared_examples 'date_range' do |target,source,options|
  let :strict do
    {
      "#{source}>" => '2010-01-02',
      "#{source}<" => '2010-01-05',
    }
  end

  let :nonstrict do
    strict.merge({
      "#{source}>=" => '2010-01-03',
      "#{source}<=" => '2010-01-04',
    })
  end

  let :exact do
    nonstrict.merge({
      source => '2010-01-01',
    })
  end

  it 'should return a criterion' do
    expect(described_class.new(input(strict, options)).convert).to eq(target => '2010-01-02:2010-01-05')
  end

  it 'should prioritize or-equal dates' do
    expect(described_class.new(input(nonstrict, options)).convert).to eq(target => '2010-01-03:2010-01-04')
  end

  it 'should prioritize exact date' do
    expect(described_class.new(input(exact, options)).convert).to eq(target => '2010-01-01:2010-01-01')
  end
end
