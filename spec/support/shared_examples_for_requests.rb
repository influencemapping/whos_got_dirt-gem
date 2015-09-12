RSpec.shared_examples 'equal' do |target,source,value,valid|
  it 'should return a criterion' do
    expect(described_class.new(source => value).convert).to eq(target => value)
  end

  if valid
    it 'should accept valid values' do
      expect(described_class.new(source => value).equal(target, source, valid)).to eq(target => value)
    end

    it 'should ignore invalid values' do
      expect(described_class.new(source => 'invalid').equal(target, source, valid)).to eq({})
    end
  end
end

RSpec.shared_examples 'match' do |target,source,values|
  let :fuzzy do
    {"#{source}~=" => values.first}
  end

  let :exact do
    fuzzy.merge(source => values.last)
  end

  it 'should return a criterion' do
    expect(described_class.new(fuzzy).convert).to eq('q' => values.first)
  end

  it 'should prioritize exact name' do
    expect(described_class.new(exact).convert).to eq('q' => values.last)
  end
end

RSpec.shared_examples 'one_of' do |target,source,values|
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
    expect(described_class.new(many).convert).to eq(target => values.join('|'))
  end

  it 'should prioritize exact match' do
    expect(described_class.new(one).convert).to eq(target => values.first)
  end

  it 'should prioritize all match' do
    expect(described_class.new(all).convert).to eq(target => values.join(','))
  end
end

RSpec.shared_examples 'date_range' do |target,source|
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
    expect(described_class.new(strict).convert).to eq(target => '2010-01-02:2010-01-05')
  end

  it 'should prioritize or-equal dates' do
    expect(described_class.new(nonstrict).convert).to eq(target => '2010-01-03:2010-01-04')
  end

  it 'should prioritize exact date' do
    expect(described_class.new(exact).convert).to eq(target => '2010-01-01:2010-01-01')
  end
end
