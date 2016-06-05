require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before(:all) do
    @user       = create(:user)
    @other_user = create(:user)
  end

  describe 'initialization' do
    before(:each) { @friendship = create(:friendship) }
    subject { @friendship }

    it { should respond_to(:friendee)   }
    it { should respond_to(:friender)   }
    it { should respond_to(:confirmed?) }

    it 'should require both leader and follower to be defined' do
      expect { create(:friendship, friender: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { create(:friendship, friendee: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should initialize with confirmed=false' do
      expect(build(:friendship).confirmed?).to eq false
    end
  end

  describe '#friend!(other_user)' do
    it 'should create a new unconfirmed Friendship' do
      expect { @user.friend!(create(:user)) }.to change { Friendship.count             }.by 1
      expect { @user.friend!(create(:user)) }.to change { Friendship.confirmed.count   }.by 0
      expect { @user.friend!(create(:user)) }.to change { Friendship.unconfirmed.count }.by 1
    end

    context 'friendship pending' do
      before(:each) do
        @friendship = create(:friendship)
        @friender   = @friendship.friender
        @friendee   = @friendship.friendee
      end

      it '#friends_with? should be false' do
        expect(@friender.friends_with?(@friendee)).to eq false
        expect(@friendee.friends_with?(@friender)).to eq false
      end

      it '#request_pending? should be true' do
        expect(@friender.request_pending?(@friendee)).to eq true
        expect(@friendee.request_pending?(@friender)).to eq true
      end

      it 'should not allow a user to double-friend another user who has not yet confirmed their friendship' do
        expect(@friender.friend!(@friendee)).to eq false
        expect(@friender.errors[:base]).to eq ["There's a pending friendship request with #{@friendee.name} already!"]
        expect { @friender.friend!(@friendee) }.to change { Friendship.count }.by 0
      end
    end

    context 'friendship confirmed' do
      before(:each) do
        @friendship = create(:friendship, confirmed: true)
        @friender   = @friendship.friender
        @friendee   = @friendship.friendee
      end

      it '#friends_with? should be true' do
        expect(@friender.friends_with?(@friendee)).to eq true
        expect(@friendee.friends_with?(@friender)).to eq true
      end

      it '#request_pending? should be false' do
        expect(@friender.request_pending?(@friendee)).to eq false
        expect(@friendee.request_pending?(@friender)).to eq false
      end

      it 'should not allow a user to double-friend another user who has confirmed their friendship' do
        expect(@friender.friend!(@friendee)).to eq false
        expect(@friender.errors[:base]).to eq ["You're already friends with #{@friendee.name}!"]
        expect { @friender.friend!(@friendee) }.to change { Friendship.count }.by 0
      end
    end

    it 'should not allow someone to friend themself' do
      expect(@user.friend!(@user)).to eq false
      expect(@user.errors[:base]).to eq ["You can't friend yourself, silly!"]
      expect { @user.friend!(@user) }.to change { Friendship.count }.by 0
    end
  end

  describe '#unfriend!' do
    context 'confirmed friendship' do
      before(:each) do
        @friendship = create(:friendship, confirmed: true)
        @friendee   = @friendship.friendee
        @friender   = @friendship.friender
      end

      it 'should destroy a friendship' do
        expect { @friendee.unfriend!(@friender) }.to change { Friendship.count }.by -1
      end

      it 'should destroy a friendship' do
        expect { @friender.unfriend!(@friendee) }.to change { Friendship.count }.by -1
      end

      it 'should return true on success' do
        expect(@friendee.unfriend!(@friender)).to eq true
      end

      it 'should return true on success' do
        expect(@friender.unfriend!(@friendee)).to eq true
      end
    end

    context 'unconfirmed friendship' do
      before(:each) do
        @unconfirmed_friendship = create(:friendship)
        @friendee = @unconfirmed_friendship.friendee
        @friender = @unconfirmed_friendship.friender
      end

      it 'should not destroy an unconfirmed friendship' do
        expect { (@friendee).unfriend!(@friender) }.to change { Friendship.count }.by 0
      end

      it 'should not destroy an unconfirmed friendship' do
        expect { (@friender).unfriend!(@friendee) }.to change { Friendship.count }.by 0
      end

      it 'should return false on failure' do
        expect(@friendee.unfriend!(@friender)).to eq false
      end

      it 'should return false on failure' do
        expect(@friender.unfriend!(@friendee)).to eq false
      end
    end

    context 'no friendship, pending or confirmed' do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }

      it 'should not destroy a friendship if they werent friends in the first place' do
        expect(user1.unfriend!(user2)).to eq false
        expect { user1.unfriend!(user2) }.to change { Friendship.count }.by 0
      end
    end
  end

  describe '#confirm!' do
    let(:friendship) { create(:friendship) }

    it 'should change from confirmed?==false to confirmed?==true' do
      expect(friendship.confirmed?).to eq false
      expect { friendship.confirm! }.to change { friendship.confirmed? }.from(false).to(true)
    end
  end

  describe 'friend lists' do
    before do
      @unconfirmed_friender = create(:friendship, friender: @user)
      @unconfirmed_friendee = create(:friendship, friendee: @user)
      @confirmed_friender   = create(:friendship, friender: @user, confirmed: true)
      @confirmed_friendee   = create(:friendship, friendee: @user, confirmed: true)
    end

    describe '#confirmed_friends' do
      it 'should return confirmed friends' do
        expect(@user.confirmed_friends).to match_array [ @confirmed_friender.friendee, @confirmed_friendee.friender ]
      end
    end

    describe '#unconfirmed_friends' do
      it 'should return unconfirmed friends' do
        expect(@user.unconfirmed_friends).to match_array [ @unconfirmed_friender.friendee, @unconfirmed_friendee.friender ]
      end
    end
  end

  context 'scope:' do
    before do
      @confirmed_friendship = create(:friendship, confirmed: true)
      @pending_friendship   = create(:friendship)
    end

    it 'Friendship.confirmed should surface friendships that are no longer pending' do
      expect(Friendship.confirmed).to match [@confirmed_friendship]
    end

    it 'Friendship.pending should surface friendships that have not yet been confirmed' do
      expect(Friendship.unconfirmed).to match [@pending_friendship]
    end
  end
end
