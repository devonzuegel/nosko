require 'rails_helper'

RSpec.describe Article, type: :model do
  # describe 'Initializing an article' do
  #   it 'requires :content' do
  #     expect(build(:article, content: nil)).to_not be_valid
  #     expect(build(:article)).to be_valid
  #     expect { create(:article) }.to change { Article.count }.by 1
  #   end

  #   it '.trash! should update finding.permalink.trashed? = true' do
  #     finding = create(:finding)
  #     expect(finding.trashed?).to be false
  #     finding.trash!
  #     expect(finding.trashed?).to be true
  #   end

  #   it 'Only allow kind="Article" for now' do
  #     %w(Other Book Podcast).each do |k|
  #       expect(build(:finding, kind: k)).to_not be_valid
  #     end
  #   end
  # end

  # describe 'Retrieving Findings' do
  #   it 'should retrieve only live (untrashed) findings'
  #   it 'should retrieve only trashed findings'
  # end
end
