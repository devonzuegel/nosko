describe UsersController, :omniauth do
  before(:all) do
    @user       = create(:user)
    @other_user = create(:user)
  end

  describe 'GET /users' do
    it 'should redirect to home page if user is not logged in' do
      get :index
      assert_response :redirect
      assert_redirected_to root_url
    end

    it 'should list other users to signed in users' do
      session[:user_id] = @user.id
      get :index
      assert_response :success
      expect(assigns(:users)).to eq [ @user, @other_user ]
    end
  end

  describe 'GET /users/:id' do
    it 'should redirect to root' do
      get :show, id: @user.id
      assert_response :redirect
      assert_redirected_to root_url
    end

    it 'shows user with :id when user logged in' do
      session[:user_id] = @user.id
      get :show, id: @user.id
      assert_response :success
      expect(assigns(:user)).to eq @user
    end
  end

  describe 'GET /settings' do
    it 'should redirect to root if user not logged in' do
      get :settings
      assert_response :redirect
      assert_redirected_to root_url
    end

    it 'should assign the current_user to the @user variable' do
      session[:user_id] = @user.id
      get :settings
      assert_response :success
      expect(assigns(:user)).to eq @user
    end
  end

  describe 'PUT /users/:id' do
    it 'should only be updatable by that user' do
      session[:user_id] = @user
      patch :update, id: @other_user.id, user: { }
      assert_redirected_to root_url
    end

    it 'updates the settings of user with :id' do
      session[:user_id] = @user
      patch :update, id: @user.id, user: { name: 'Updated name' }
      assert_response :success
      @user = User.find(@user.id)
      expect(@user.name).to eq 'Updated name'
    end
  end

  describe 'PUT /users/:id/follow', :focus do
    before(:each) do
      Following.destroy_all
      @user.reload
      @other_user.reload
    end

    it 'should redirect to root if user not logged in' do
      get :follow, id: @other_user
      assert_response :redirect
      assert_redirected_to root_url
    end

    it 'should allow you to follow another person' do
      session[:user_id] = @user.id

      expect(@user.leaders).to         eq []
      expect(@other_user.followers).to eq []

      request.env['HTTP_REFERER'] = root_url  # To test `redirect_to :back`
      get :follow, id: @other_user

      assert_redirected_to root_url
      expect(flash[:notice]).to eq "Followed user ##{@other_user.id}"

      @user.reload
      @other_user.reload

      expect(@user.leaders).to         match [@other_user]
      expect(@other_user.followers).to match [@user]
    end

    it 'should not allow you to follow yourself' do
      session[:user_id] = @user.id

      expect(@user.leaders).to   eq []
      expect(@user.followers).to eq []

      request.env['HTTP_REFERER'] = root_url  # To test `redirect_to :back`
      get :follow, id: @user

      assert_redirected_to root_url
      expect(flash[:alert]).to eq "You can't follow yourself, silly!"

      @user.reload

      expect(@user.leaders).to   match []
      expect(@user.followers).to match []
    end

    it 'should not allow you to follow the same person twice' do
      session[:user_id] = @user.id
      @user.follow!(@other_user)

      expect(@user.leaders).to         match [@other_user]
      expect(@other_user.followers).to match [@user]

      request.env['HTTP_REFERER'] = root_url  # To test `redirect_to :back`
      get :follow, id: @other_user

      assert_redirected_to root_url
      expect(flash[:alert]).to eq "You're already following user ##{@other_user.id}"

      @user.reload

      expect(@user.leaders).to         match [@other_user]
      expect(@other_user.followers).to match [@user]
    end
  end

  describe 'PUT /users/:id/unfollow' do
    before(:each) do
      Following.destroy_all
      @user.reload
      @other_user.reload
    end

    it 'should redirect to root if user not logged in' do
      get :unfollow, id: @other_user
      assert_response :redirect
      assert_redirected_to root_url
    end

    it 'should allow you to unfollow a person if youre already following them' do
      session[:user_id] = @user.id
      @user.follow!(@other_user)

      expect(@user.leaders).to         eq [@other_user]
      expect(@other_user.followers).to eq [@user]

      request.env['HTTP_REFERER'] = root_url  # To test `redirect_to :back`
      get :unfollow, id: @other_user

      assert_redirected_to root_url
      expect(flash[:notice]).to eq "Unfollowed user ##{@other_user.id}"

      @user.reload
      @other_user.reload

      expect(@user.leaders).to         match []
      expect(@other_user.followers).to match []
    end

    it 'should not allow you to unfollow someone you arent following' do
      session[:user_id] = @user.id

      expect(@user.leaders).to         eq []
      expect(@other_user.followers).to eq []

      request.env['HTTP_REFERER'] = root_url  # To test `redirect_to :back`
      get :unfollow, id: @other_user

      assert_redirected_to root_url
      expect(flash[:alert]).to eq "You weren't following user ##{@other_user.id}"

      @user.reload
      @other_user.reload

      expect(@user.leaders).to         match []
      expect(@other_user.followers).to match []
    end
  end
end
