require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe WhosGotDirt do
  describe '.schemas' do
    it 'should return the schemas' do
      expect(WhosGotDirt.schemas['popolo'].class).to eq(Hash)
    end
  end
end
