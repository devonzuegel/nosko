require 'rails_helper'

RSpec.describe EvernoteNote, type: :model do
  describe 'basic model' do
    it 'should be valid' do
      expect(build(:evernote_note).valid?).to be true
    end

    it 'should create an evernote_note' do
      expect { create(:evernote_note) }.to change { EvernoteNote.count }.by 1
    end

    it 'should create a corresponding article' do
      expect { create(:evernote_note) }.to change { Article.count }.by 1
    end
  end

  # subject { build(:evernote_note) }

  # it { should validate_presence_of(:guid)          }
  # it { should validate_presence_of(:article)       }
  # it { should validate_presence_of(:en_created_at) }
  # it { should validate_presence_of(:en_updated_at) }
  # it { should validate_presence_of(:active)        }
  # it { should validate_presence_of(:notebook_guid) }
  # it { should validate_presence_of(:author)        }
  # it { should validate_presence_of(:article)       }

  # it { should validate_uniqueness_of(:guid)        }
  # it { should validate_uniqueness_of(:article)     }
end
