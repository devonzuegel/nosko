describe FindingsController, :omniauth do
  before(:all) do
    @user     = create(:user)
    @friend   = create(:user)
    @stranger = create(:user)
  end

  let(:article) { create(:article, user: @stranger) }

  context 'json format'do
    describe 'GET /finding/:permalink => #show' do
      describe 'when not signed in' do
        it 'should surface a public finding' do
          get :show, permalink: article.to_param, format: :json
          result = JSON.parse(response.body).deep_symbolize_keys!
          expect(result).to eq article.decorate.as_prop
          assert_response :success
        end

        it 'should not surface a person\'s friend-only finding'
        it 'should not surface a private finding'

        it 'should return a 404 when given an invalid permalink' do
          get :show, permalink: '123123', format: :json
          assert_response :not_found
        end
      end

      describe 'when signed in' do
        it 'should surface a public finding' do
          session[:user_id] = @user.id

          get :show, permalink: article.to_param, format: :json
          result = JSON.parse(response.body).deep_symbolize_keys!
          expect(result).to eq article.decorate.as_prop
          assert_response :success
        end

        it 'should surface a friend\'s friend-only finding'
        it 'should not surface a stranger\'s friend-only finding'
        it 'should not surface a private finding'

        it 'should return a 404 when given an invalid permalink' do
          session[:user_id] = @user.id

          get :show, permalink: '123123', format: :json
          assert_response :not_found
        end
      end

      it 'should handle other types of findings too (which havent yet been implemented)'
    end
  end

  context 'html format' do
    describe 'GET /finding/:permalink => #show' do
      describe 'when not signed in' do
        it 'should surface a public finding'  do
          get :show, permalink: article.to_param
          expect(assigns(:article)).to eq article.decorate
          assert_response :success
        end

        it 'should not surface a person\'s friend-only finding'
        it 'should not surface a private finding'

        it 'should return a 404 when given an invalid permalink' do
          get :show, permalink: '123123123213'
          assert_response :not_found
          expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        end
      end

      describe 'when signed in' do
        before do
          session[:user_id] = @user.id
        end

        it 'should surface a public finding'  do
          get :show, permalink: article.to_param
          expect(assigns(:article)).to eq article.decorate
          assert_response :success
        end

        it 'should surface a friend\'s friend-only finding'
        it 'should not surface a stranger\'s friend-only finding'
        it 'should not surface a private finding'
        it 'should return a 404 when given an invalid permalink' do
          session[:user_id] = @user.id

          get :show, permalink: '123123'
          assert_response :not_found
          expect(response).to render_template(file: "#{Rails.root}/public/404.html")
        end
      end

      it 'should handle other types of findings too (which havent yet been implemented)'
    end
  end
end