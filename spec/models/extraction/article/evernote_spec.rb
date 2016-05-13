require 'rails_helper'

RSpec.describe Extractor::Article::Evernote, type: :model do
  it 'should have the expected table_name' do
    expect(Extractor::Article::Evernote.table_name).to eq 'evernote_extractors'
  end

  describe 'Initializing an Evernote extractor' do
    it 'should build a valid extractor'
    it 'should require a non-blank article_extraction'
    it 'should require a non-blank api_token'
    it 'should require a unique article_extraction'
    it 'should require a unique api_token'
  end

  it 'should update an article if it is unlocked'
  it 'should not update an article if it is locked'
end
