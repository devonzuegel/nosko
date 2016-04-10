require 'rails_helper'

RSpec.describe Finding::Article, type: :model do
  describe 'Initializing an article' do
    it 'should build a valid article' do
      expect(build(:article)).to be_valid
      expect { create(:article) }.to change { Finding::Article.count }.by 1
    end

    it 'requires expected required fields' do
      expect(Finding::Article.required_fields).to match_array %i(title content user_id)
      Finding::Article.required_fields.each do |field|
        expect(build(:article, field => nil)).to_not be_valid
      end
    end

    it 'shouldn\'t require expected optional fields' do
      expect(Finding::Article.optional_fields).to match_array %i(source_url)
      Finding::Article.optional_fields.each do |field|
        expect(build(:article, field => nil)).to be_valid
      end
    end

    it '.trash! should update article.permalink.trashed? = true' do
      article = create(:article)
      expect(article.trashed?).to be false
      article.trash!
      expect(article.trashed?).to be true
    end

    it 'should generate a permalink on creation' do
      expect { create(:article) }.to change { Permalink.count }.by 1
    end

  end

  describe 'Retrieving articles' do
    it 'should retrieve only live (untrashed) articles'
    it 'should retrieve only trashed articles'
  end
end
