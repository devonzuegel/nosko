require 'rails_helper'

RSpec.describe Finding::Article, type: :model do
  describe 'Initializing an article' do
    it 'should build a valid article' do
      expect(build(:article)).to be_valid
      expect { create(:article) }.to change { Finding::Article.count }.by 1
    end

    it 'should generate a permalink on creation' do
      expect { create(:article) }.to change { Permalink.count }.by 1
    end

    it 'requires expected required fields' do
      expect(Finding::Article.required_fields).to match_array %i(title content user_id locked visibility)
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

    it 'should be not locked by default' do
      article = create(:article)
      expect(article.locked).to eq false
    end
  end

  describe 'generating permalink' do
    before(:all) do
      @article = create(:article)
    end

    it 'generate_permalink should not create a new permalink if the Article already has one' do
      expect { @article.generate_permalink }.to change { Permalink.count }.by 0
    end

    it 'generate_permalink! should create a new permalink even if the Article already has one' do
      expect { @article.generate_permalink! }.to change { Permalink.count }.by 1
    end

    it 'generate_permalink! should update the article\'s permalink and mark the old one as trashed' do
      old_permalink = @article.permalink
      @article.generate_permalink!
      expect(@article.permalink.id).to_not eq old_permalink.id
    end
  end

  describe 'Retrieving articles' do
    before(:all) do
      Finding::Article.destroy_all
      create(:article)
      create(:article, :trashed)
    end

    it 'should retrieve only live (untrashed) articles' do
      active = Finding::Article.active
      expect(active.count).to eq 1
      active.each { |a| expect(a.trashed?).to eq false }
    end

    it 'should retrieve only trashed articles' do
      trashed = Finding::Article.trashed
      expect(trashed.count).to eq 1
      trashed.each { |a| expect(a.trashed?).to eq true }
    end
  end

  describe '(un)locking' do
    it 'should allow you to lock the article' do
      article = create(:article)
      expect(article.locked?).to eq false
      article.lock!
      expect(article.locked?).to eq true
    end

    it 'should allow you to unlock the article' do
      article = create(:article, :locked)
      expect(article.locked?).to eq true
      article.unlock!
      expect(article.locked?).to eq false
    end
  end

  describe 'the sharing status' do
    let(:private_user) { create(:user) }
    let(:public_user)  { create(:user, :public_by_default) }

    it 'should be "just me" by default if the user\'s sharing preferences indicate "just me" by default' do

    end
    it 'should be "public" by default if the user\'s sharing preferences indicate "public" by default' do

    end

    it 'should allow me to change the status from "just me" to "public"'

    it 'should allow me to change the status from "public" to "just me"'
  end
end
