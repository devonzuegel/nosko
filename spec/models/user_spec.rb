describe User do

  describe 'initializing basic model' do
    before(:each) { @user = create(:user) }

    subject { @user }

    it { should respond_to(:name)             }
    it { should respond_to(:provider)         }

    it { should respond_to(:evernote_account) }
    it { should respond_to(:articles)         }
    it { should respond_to(:leaders)          }
    it { should respond_to(:followers)        }
    it { should respond_to(:sharing)          }

    it '#name returns a string' do
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

    it 'should initially not have any leaders' do
      expect(@user.leaders).to match []
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
