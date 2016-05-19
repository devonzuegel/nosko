describe FollowingsController do
  before(:all) do
    @user       = create(:user)
    @other_user = create(:user)
  end

  describe 'PUT /follow/:id'  do
    before(:each) do
      Following.destroy_all
      @user.reload
      @other_user.reload
    end

    it 'should return an error if user not logged in' do
      get :follow, id: @other_user, format: :json
      assert_response :unauthorized
    end

    it 'should allow you to follow another person' do
      session[:user_id] = @user.id

      expect(@user.leaders).to         eq []
      expect(@other_user.followers).to eq []

      get :follow, id: @other_user, format: :json
      assert_response :success

      @user.reload
      @other_user.reload

      expect(@user.leaders).to         match [@other_user]
      expect(@other_user.followers).to match [@user]
    end

    it 'should not allow you to follow yourself' do
      session[:user_id] = @user.id

      expect(@user.leaders).to   eq []
      expect(@user.followers).to eq []

      get :follow, id: @user, format: :json
      assert_response :unprocessable_entity
      expect(JSON.parse(response.body)).to eq({ 'errors' => ["You can't follow yourself, silly!"] })

      @user.reload

      expect(@user.leaders).to   match []
      expect(@user.followers).to match []
    end

    it 'should not allow you to follow the same person twice' do
      session[:user_id] = @user.id
      @user.follow!(@other_user)

      expect(@user.leaders).to         match [@other_user]
      expect(@other_user.followers).to match [@user]

      get :follow, id: @other_user, format: :json
      assert_response :unprocessable_entity
      expect(JSON.parse(response.body)).to eq({ 'errors' => ["You're already following user ##{@other_user.id}"] })

      @user.reload

      expect(@user.leaders).to         match [@other_user]
      expect(@other_user.followers).to match [@user]
    end
  end

  describe 'GET /unfollow/:id' do
    before(:each) do
      Following.destroy_all
      @user.reload
      @other_user.reload
    end

    it 'should return an error if user not logged in' do
      get :unfollow, id: @other_user, format: :json
      assert_response :unauthorized
    end

    it 'should allow you to unfollow a person if youre already following them' do
      session[:user_id] = @user.id
      @user.follow!(@other_user)

      expect(@user.leaders).to         eq [@other_user]
      expect(@other_user.followers).to eq [@user]

      get :unfollow, id: @other_user, format: :json
      assert_response :success

      @user.reload
      @other_user.reload

      expect(@user.leaders).to         match []
      expect(@other_user.followers).to match []
    end

    it 'should not allow you to unfollow someone you arent following' do
      session[:user_id] = @user.id

      expect(@user.leaders).to         eq []
      expect(@other_user.followers).to eq []

      get :unfollow, id: @other_user, format: :json
      assert_response :unprocessable_entity
      expect(JSON.parse(response.body)).to eq({ 'errors' => ["You weren't following user ##{@other_user.id}"] })

      @user.reload
      @other_user.reload

      expect(@user.leaders).to         match []
      expect(@other_user.followers).to match []
    end
  end
end