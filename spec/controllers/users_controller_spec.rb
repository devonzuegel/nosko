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
    it 'should only be updatable by that user'
    it 'updates the settings of user with :id'
    it 'should assign @user as expected'
  end

  describe '/users/:id/follow' do
    it 'should redirect to ...'
    it 'ADD MORE SPECS'
  end

  describe '/users/:id/unfollow' do
    it 'should redirect to ...'
    it 'ADD MORE SPECS'
  end
end
