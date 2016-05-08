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
end