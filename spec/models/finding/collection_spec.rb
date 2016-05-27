require 'rails_helper'

RSpec.describe Finding::Collection, type: :model do
  describe 'Initializing a collection' do
    let(:user)    { create(:user) }
    before(:each) { @collection = Finding::Collection.new(user) }
    subject       { @collection }

    it { should respond_to :all }

    it 'should require you pass a user' do
      expect { Finding::Collection.new }.to raise_error ArgumentError
    end
  end

  describe '.all' do
    before do
      @user       = create(:user)
      @collection = Finding::Collection.new(@user)
      traits = Shareable::SHARE_BY_DEFAULT_ENUM.keys.map { |k| k.downcase.tr(' ', '_').to_sym }
      traits.each { |t| create(:article, t, user: @user) }
    end

    it 'does something' do
      expect(@collection.all).to match @user.articles
      expect(@collection.all.length).to eq 3
    end
  end

  it 'should have the expected sibling constants' do
    expect(Finding.constants).to match %i(Article Findable Collection)
  end
end
