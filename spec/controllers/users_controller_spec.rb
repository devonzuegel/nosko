describe UsersController, :omniauth do
  before(:all) do
    User.destroy_all
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
      expect(assigns(:users).map(&:id)).to eq [ @user, @other_user ].map(&:id)
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
end
