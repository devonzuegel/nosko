require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'Initializing an article' do
    it 'should build a valid article' do
      expect(build(:article)).to be_valid
      expect { create(:article) }.to change { Article.count }.by 1
    end

    it 'requires expected required fields' do
      expect(Article::REQUIRED_FIELDS).to match_array %i(title source_url content user)
      Article::REQUIRED_FIELDS.each do |field|
        next if field == :user
        expect(build(:article, field => nil)).to_not be_valid
      end
    end

    it 'shouldn\'t require expected optional fields' do
      expect(Article::OPTIONAL_FIELDS).to match_array %i()
      Article::OPTIONAL_FIELDS.each do |field|
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
