RSpec.shared_examples 'equal' do |target,source,value|
  it 'should return a criterion' do
    expect(described_class.new(source => value).convert).to eq(target => value)
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

  it 'should return a criterion' do
    expect(described_class.new(many).convert).to eq(target => values.join('|'))
  end

  it 'should prioritize exact jurisdiction' do
    expect(described_class.new(one).convert).to eq(target => values.first)
  end
end
