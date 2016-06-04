require 'rails_helper'

RSpec.describe Following, type: :model do
  before(:all) do
    @user       = create(:user)
    @other_user = create(:user)
  end

  it 'should not allow a user to double-follow another user' do
    @user.follow!(@other_user)
    expect(@user.follow!(@other_user)).to eq false
    expect(@user.errors.full_messages).to eq ["You're already following user ##{@other_user.id}"]
  end

  it 'should require both leader and follower to be defined' do
    expect { @user.follow!(nil) }.to raise_error ActiveRecord::RecordInvalid
  end

  describe '(un)following another user' do
    before(:each) do
      @follower = create(:user)
      @leader   = create(:user)
    end

    it 'should make sure that follower has a single leader & leader has a single follower' do
      expect(@follower.leaders).to match []
      expect(@leader.followers).to match []

      @follower.follow!(@leader)
      @follower.reload
      @leader.reload

      expect(@follower.leaders).to match [@leader]
      expect(@leader.followers).to match [@follower]
    end

    it 'should make sure that after unfollowing, the follower has 0 leaders & the leader has 0 followers' do
      @follower.follow!(@leader)
      @follower.reload

      @follower.unfollow!(@leader)
      @follower.reload
      expect(@follower.leaders).to match []
      expect(@leader.followers).to match []
    end
  end
end