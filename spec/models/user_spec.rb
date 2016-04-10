describe User do

  describe 'initializing basic model' do
    before(:each) { @user = create(:user) }

    subject { @user }

    it { should respond_to(:name)             }
    it { should respond_to(:sharing)          }
    it { should respond_to(:evernote_account) }

    it "#name returns a string" do
      expect(@user.name).to match 'Test User'
    end

    it 'should initially have an empty evernote_account' do
      expect(@user.evernote_account.auth_token).to be nil
      expect(@user.evernote_connected?).to         be false
    end
  end

  describe 'connecting to evernote' do
    before(:each) do
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

    it 'should enque a SyncEvernoteAccount job'
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
end
