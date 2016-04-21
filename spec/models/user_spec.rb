describe User do

  describe 'initializing basic model' do
    before(:each) { @user = create(:user) }

    subject { @user }

    it { should respond_to(:name)             }
    it { should respond_to(:sharing)          }
    it { should respond_to(:articles)         }
    it { should respond_to(:evernote_account) }
    it { should respond_to(:followers) }
    it { should respond_to(:followings) }

    it "#name returns a string" do
      expect(@user.name).to match 'Test User'
    end

    it 'should initially have an empty evernote_account' do
      expect(@user.evernote_account.auth_token).to be nil
      expect(@user.evernote_connected?).to         be false
    end

    it 'should initially not have any articles' do
      expect(@user.articles).to match []
    end

    it 'should initially not have any followers' do
      expect(@user.followers).to match []
    end

    it 'should initially not have any followings' do
      expect(@user.followings).to match []
    end
  end

  describe 'connecting to evernote' do
    before(:each) do
      stub_const('EvernoteClient', FakeEvernoteClient)
      @user        = create(:user)
      @dummy_creds = { 'credentials' => { 'token' => Faker::Lorem.characters(20) } }
    end

    it 'should say that evernote is connected' do
      @user.connect_evernote(@dummy_creds)
      expect(@user.evernote_connected?).to be true
    end

    it 'should store the evernote credentials' do
      @user.connect_evernote(@dummy_creds)
      expect(@user.evernote_account.auth_token).to eq @dummy_creds['credentials']['token']
    end

    it 'should enqueue a SyncEvernoteAccount job' do
      # require 'que/testing'

      connect = -> { @user.connect_evernote(@dummy_creds) }
      expect { connect.call }.to change { SyncEvernoteAccount.jobs.length }.by 1
    end
  end

  describe 'creating a User' do
    subject { -> { @user = create(:user) } }

    it { should change(Sharing,         :count).by 1 }
    it { should change(EvernoteAccount, :count).by 1 }
  end

  describe 'destroying a user' do
    before(:each) { @user = create(:user) }

    subject { -> { @user.destroy } }

    it { should change(Sharing,         :count).by -1 }
    it { should change(EvernoteAccount, :count).by -1 }
  end

  describe '.evernote_connected?' do
    it 'should be true if it has not been connected' do
      expect(create(:user).evernote_connected?).to be false
    end

    it 'should be true if it has been connected' do
      expect(create(:user, :evernote_connected).evernote_connected?).to be true
    end
  end

  describe 'following another user' do
    before(:each) do
      @follower = create(:user)
      @leader   = create(:user)
    end

    it 'should have a single following' do
      expect(@follower.followings).to match []
      Following.create!(leader: @leader, follower: @follower)
      @follower = User.find(@follower.id)
      expect(@follower.followings.map(&:leader_id)).to match [@leader.id]
    end
  end

  describe 'being followed by another user' do
    before(:each) do
      @follower = create(:user)
      @leader   = create(:user)
    end

    it 'should have a single following' do
      expect(@leader.followers).to match []
      Following.create!(leader: @leader, follower: @follower)
      @leader = User.find(@leader.id)
      expect(@leader.followers.map(&:follower_id)).to match [@follower.id]
    end
  end
end
