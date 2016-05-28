require 'rails_helper'

RSpec.describe Finding::Collection, type: :model do
  describe 'Initializing a collection' do
    let(:user)        { create(:user) }
    let(:collection)  { Finding::Collection.new(user) }
    subject           { collection }

    it { should respond_to :all     }
    it { should respond_to :public  }
    it { should respond_to :only_me }
    it { should respond_to :friends }

    it 'should require you pass a user' do
      expect { Finding::Collection.new }.to raise_error ArgumentError
    end
  end

  before do
    @user       = create(:user)
    @collection = Finding::Collection.new(@user)
    traits = Shareable::SHARE_BY_DEFAULT_ENUM.keys.map { |k| k.downcase.tr(' ', '_').to_sym }
    traits.each { |t| create(:article, t, user: @user) }

    create(:article)  # An article that doesn't belong to @user
  end

  describe '.all' do
    it 'retrieve all of the user\'s articles' do
      expect(@collection.all).to match @user.articles
      expect(@collection.all.length).to eq 3
    end
  end

  describe '.public' do
    it 'retrieve only the user\'s Public articles' do
      expect(@collection.public).to match @user.articles.where(visibility: 'Public')
      expect(@collection.public.length).to eq 1
    end
  end

  describe '.only_me' do
    it 'retrieve only the user\'s "Only me" articles' do
      expect(@collection.only_me).to match @user.articles.where(visibility: 'Only me')
      expect(@collection.only_me.length).to eq 1
    end
  end

  describe '.friends' do
    it 'retrieve only the user\'s Friends articles' do
      expect(@collection.friends).to match @user.articles.where(visibility: 'Friends')
      expect(@collection.friends.length).to eq 1
    end
  end

  # The following specs will expand over time as we add more finding types

  it 'should have the expected finding types listed' do
    expect(Finding::Collection::TYPES).to eq({ article: Finding::Article })
  end

  it 'should have the expected sibling constants' do
    expect(Finding.constants).to match %i(Article Findable Collection)
  end
end
