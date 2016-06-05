describe FriendshipsController do
  before(:all) do
    @user       = create(:user)
    @other_user = create(:user)
  end

  describe 'PUT /friend/:id'  do
    before(:each) do
      Friendship.destroy_all
      @user.reload
      @other_user.reload
    end

    it 'should return an error if user not logged in' do
      get :friend, id: @other_user, format: :json
      assert_response :unauthorized
    end

    it 'should allow you to friend another person' do
      session[:user_id] = @user.id

      expect(@user.request_pending?(@other_user)).to eq false
      expect(@other_user.request_pending?(@user)).to eq false

      get :friend, id: @other_user, format: :json
      assert_response :success

      @user.reload
      @other_user.reload

      expect(@user.request_pending?(@other_user)).to eq true
      expect(@other_user.request_pending?(@user)).to eq true

      expect(@user.unconfirmed_friends).to match [@other_user]
      expect(@other_user.unconfirmed_friends).to match [@user]
    end

    it 'should not allow you to friend yourself' do
      session[:user_id] = @user.id
      expect(@user.request_pending?(@user)).to eq false

      get :friend, id: @user, format: :json
      assert_response :unprocessable_entity
      expect(JSON.parse(response.body)).to eq({ 'errors' => ["You can't friend yourself, silly!"] })

      @user.reload

      expect(@user.confirmed_friends).to   match []
      expect(@user.unconfirmed_friends).to match []
    end

    it 'should not allow you to friend request the same person twice' do
      session[:user_id] = @user.id
      @user.friend!(@other_user)

      expect(@user.request_pending?(@other_user)).to eq true
      expect(@other_user.request_pending?(@user)).to eq true

      get :friend, id: @other_user, format: :json
      assert_response :unprocessable_entity
      expect(JSON.parse(response.body)).to eq({
        'errors' => ["There's a pending friendship request with #{@other_user.name} already!"]
      })

      @user.reload
      @other_user.reload

      expect(@user.request_pending?(@other_user)).to eq true
      expect(@other_user.request_pending?(@user)).to eq true

      expect(@user.unconfirmed_friends).to match [@other_user]
      expect(@other_user.unconfirmed_friends).to match [@user]
    end
  end

  describe 'GET /unfollow/:id' do
    before(:each) do
      Following.destroy_all
      @user.reload
      @other_user.reload
    end

    it 'should return an error if user not logged in' do
      get :unfriend, id: @other_user, format: :json
      assert_response :unauthorized
    end

    it 'should allow you to unfriend a person if youre already confirmed friends with them' do
      session[:user_id] = @user.id
      @user.friend!(@other_user)
      friendship = Friendship.where(friender: @user, friendee: @other_user).first
      friendship.confirm!
      expect(friendship.confirmed?).to eq true

      expect(@user.confirmed_friends).to       eq [@other_user]
      expect(@other_user.confirmed_friends).to eq [@user]

      get :unfriend, id: @other_user, format: :json
      assert_response :success

      @user.reload
      @other_user.reload

      expect(@user.confirmed_friends).to       match []
      expect(@other_user.confirmed_friends).to match []
    end

    it 'should not allow you to unfriend someone you arent confirmed friends with' do
      session[:user_id] = @user.id
      @user.friend!(@other_user)

      expect(@user.unconfirmed_friends).to       eq [@other_user]
      expect(@other_user.unconfirmed_friends).to eq [@user]

      get :unfriend, id: @other_user, format: :json
      assert_response :unprocessable_entity
      expect(JSON.parse(response.body)).to eq({
        'errors' => ["You weren't friends with user ##{@other_user.id}"]
      })

      @user.reload
      @other_user.reload

      expect(@user.unconfirmed_friends).to       match [@other_user]
      expect(@other_user.unconfirmed_friends).to match [@user]
    end
  end

  it 'should allow you to delete friend requests'
end