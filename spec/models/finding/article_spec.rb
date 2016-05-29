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
      req_fields =  %i(title content user_id locked visibility reviewed)
      expect(Finding::Article.required_fields).to match_array req_fields
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

  describe 'user ownership' do
    let(:user)       { create(:user)                }
    let(:other_user) { create(:user)                }
    let(:article)    { create(:article, user: user) }

    it 'should say that the article is owned by user' do
      expect(article.owned_by?(user)).to eq true
    end

    it 'should say that the article is owned by user' do
      expect(article.owned_by?(other_user)).to eq false
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

  describe 'visibility' do
    let(:private_user)  { create(:user)                           }
    let(:friends_user)  { create(:user, :only_friends_by_default) }
    let(:public_user)   { create(:user, :public_by_default)       }

    it 'should be "Only me" by default if the user\'s sharing preferences indicate "Only me" by default' do
      article = create(:article, user: private_user)
      expect(article.visibility).to eq 'Only me'
    end

    it 'should be "Friends" by default if the user\'s sharing preferences indicate "Friends" by default' do
      article = create(:article, user: friends_user)
      expect(article.visibility).to eq 'Friends'
    end

    it 'should be "Public" by default if the user\'s sharing preferences indicate "Public" by default' do
      article = create(:article, user: public_user)
      expect(article.visibility).to eq 'Public'
    end

    it 'shouldnt allow non-enumerated visibility' do
      article = create(:article, user: private_user)
      expect { article.update_visibility('asdflkjsaflk') }.to raise_error ArgumentError
    end

    it 'should allow me to change the status from "Only Me" visibility to "Friends" and "Public"' do
      article = create(:article, user: private_user)
      expect { article.update_visibility('Friends') }
        .to change { article.visibility }.from('Only me').to('Friends')

      article = create(:article, user: private_user)
      expect { article.update_visibility('Public') }
        .to change { article.visibility }.from('Only me').to('Public')
    end

    it 'should allow me to change the status from "Friends" visibility to "Only me" and "Public"' do
      article = create(:article, user: friends_user)
      expect { article.update_visibility('Only me') }
        .to change { article.visibility }.from('Friends').to('Only me')

      article = create(:article, user: friends_user)
      expect { article.update_visibility('Public') }
        .to change { article.visibility }.from('Friends').to('Public')
    end

    it 'should allow me to change the status from "Public" visibility to "Only me" and "Friends"' do
      article = create(:article, user: public_user)
      expect { article.update_visibility('Only me') }
        .to change { article.visibility }.from('Public').to('Only me')

      article = create(:article, user: public_user)
      expect { article.update_visibility('Friends') }
        .to change { article.visibility }.from('Public').to('Friends')
    end

    it 'should have the right index' do
      visibilities = { 'Only me' => 0, 'Friends' => 1, 'Public' => 2 }
      expect(Finding::Article.visibilities).to eq visibilities
    end
  end

  describe 'review status' do
    let(:unreviewed_article) { create(:article) }
    let(:reviewed_article)   { create(:article, reviewed: true) }

    it 'should be unreviewed' do
      expect(unreviewed_article.reviewed?).to  eq false
      expect(unreviewed_article.visibility).to eq 'Only me'
    end

    it 'should be reviewed' do
      expect(reviewed_article.reviewed?).to  eq true
      expect(reviewed_article.visibility).to eq 'Only me'
    end

    it 'updating the visibility should change status from "unreviewed" to "reviewed"' do
      expect { unreviewed_article.update_visibility('Public') }
          .to change { unreviewed_article.reviewed? }
          .from(false).to true
    end
  end
end
