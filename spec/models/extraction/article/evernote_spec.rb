require 'rails_helper'

RSpec.describe Extraction::Article::Evernote, type: :model do
  it 'should have the expected table_name' do
    expect(Extraction::Article::Evernote.table_name).to eq 'evernote_article_extractions'
  end

  describe 'Initializing an Evernote extractor' do
    it 'should build a valid extractor'
    it 'should require a non-blank article_extraction'
    it 'should require a non-blank api_token'
    it 'should require a unique article_extraction'
    it 'should require a unique api_token'
  end
end
