# frozen_string_literal: true

require_relative '../lib/save_game'

describe SaveGame do
  describe '#save' do
    data = '123'
    subject(:save_game) { described_class.new(data) }

    before do
      allow(save_game).to receive(:puts)
      allow(save_game).to receive(:gets).and_return('spec_test')
    end

    it 'creates a file' do
      save_game.save
      expect(File.exist?('./save_files/spec_test')).to be(true)
    end

    it 'creates a file with data' do
      save_game.save
      expect(File.zero?('./save_files/spec_test')).to be(false)
    end
  end
end
