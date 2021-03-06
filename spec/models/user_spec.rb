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
    it { should respond_to(:findings)         }

    it '#name returns a string' do
      expect(@user.name).to match 'Test User'
    end

    it 'should initially have an empty evernote_account' do
      expect(@user.evernote_account.auth_token).to be nil
      expect(@user.evernote_connected?).to         be false
    end

    it 'should initially have an empty facebook_account' do
      expect(@user.facebook_account.auth_token).to be nil
      expect(@user.facebook_connected?).to         be false
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

    it 'should allow assignment of various visibilities' do
      expect(create(:article, :public).visibility).to  eq 'Public'
      expect(create(:article, :only_me).visibility).to eq 'Only me'
      expect(create(:article, :friends).visibility).to eq 'Friends'
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

  describe 'connecting to evernote' do
    before(:each) do
      @user        = create(:user)
      #@dummy_creds = { 'credentials' => { 'token' => Faker::Lorem.characters(20) } }
    end

    it 'should say that facebook is connected'
    it 'should store the facebook credentials'
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

  describe 'retrieve user\'s findings' do
    before do
      Finding::Article.destroy_all
      @user = create(:user)
      traits = Shareable::SHARE_BY_DEFAULT_ENUM.keys.map { |k| k.downcase.tr(' ', '_').to_sym }
      traits.each { |t| create(:article, t, user: @user) }
    end

    it 'should match the user\'s articles (for now, until we add new kinds of findings)' do
      expect(@user.findings.map &:title).to match @user.articles.map &:title
      expect(@user.findings.length).to eq 3
    end
  end
end
