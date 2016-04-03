require 'rails_helper'

describe ArticleExtraction, type: :model do
  it { should define_enum_for(:source).with(%i(evernote)) }

  describe 'Initializing an ArticleExtraction' do
    it 'should build a valid extraction' do
      expect( build(:article_extraction) ).to be_valid
      expect { create(:article_extraction) }.to change { ArticleExtraction.count }.by 1
    end

    it 'should require a source' do
      expect( build(:article_extraction, source: nil) ).to_not be_valid
    end

    it 'have the expected enumerated sources' do
      expect(ArticleExtraction.sources.keys).to match %w(evernote)
    end
  end
end
