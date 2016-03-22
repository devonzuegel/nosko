require 'rails_helper'

RSpec.describe Highlight, type: :model do
  describe 'initializing a highlight' do
    # it 'requires :title, :kind, and :url' do
    #   expect(build(:finding, title: nil)).to_not be_valid
    #   expect(build(:finding, kind:  nil)).to_not be_valid
    #   expect(build(:finding, url:   nil)).to_not be_valid
    #   expect(build(:finding, title: nil, kind:  nil)).to_not be_valid
    #   expect(build(:finding, title: nil, url:   nil)).to_not be_valid
    #   expect(build(:findi
    #   expect(build(:finding, title: nil, kind:  nil, url: nil)).to_not be_valid
    #   expect(build(:finding)).to be_valid
    #   expect { create(:finding) }.to change { Finding.count }.by 1
    # end

    # it 'should generate a permalink on creation' do
    #   expect { create(:finding) }.to change { Permalink.count }.by 1
    # end

    # it '.trash! should update finding.permalink.trashed? = true' do
    #   finding = create(:finding)
    #   expect(finding.trashed?).to be false
    #   finding.trash!
    #   expect(finding.trashed?).to be true
    # end
  end
end
