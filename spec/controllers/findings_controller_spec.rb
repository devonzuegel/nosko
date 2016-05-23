describe FindingsController, :omniauth do
  before(:all) do
    @user     = create(:user)
    @friend   = create(:user)
    @stranger = create(:user)
  end

  let(:article)    { create(:article, user: @stranger) }
  let(:my_article) { create(:article, user: @user) }

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

    describe 'GET /finding/:permalink/lock => #lock' do
      it 'should not allow you to lock a finding when you are not signed in'
      it 'should not allow you to lock a finding when it doesnt belong to you'
      it 'should lock the finding when it belongs to you' do
        session[:user_id] = @user.id
        expect(my_article.locked).to eq false

        get :lock, permalink: my_article.to_param, format: :json

        assert_response :success
        my_article.reload
        expect(my_article.locked).to eq true
      end
    end

    describe 'GET /finding/:permalink/unlock => #unlock' do
      let(:locked_article) { create(:article, :locked, user: @user) }

      it 'should not allow you to unlock a finding when you are not signed in'

      it 'should not allow you to unlock a finding when it doesnt belong to you'

      it 'should unlock the finding when it belongs to you' do
        session[:user_id] = @user.id
        expect(locked_article.locked).to eq true

        get :unlock, permalink: locked_article.to_param, format: :json

        assert_response :success
        locked_article.reload
        expect(locked_article.locked).to eq false
      end
    end

    it 'should collapse the lock/unlock endpoints into the PATCH'

    describe 'PATCH /finding/:permalink' do
      context 'updating the finding\'s visibility' do
        it 'should allow you to update the finding\'s :visibility if it belongs to you' do
          session[:user_id] = @user.id
          expect(my_article.visibility).to eq 'Only me'

          patch :update, permalink: my_article.to_param, article: { visibility: 'Public' }, format: :json
          assert_response :success
          my_article.reload
          expect(my_article.visibility).to eq 'Public'
        end

        it 'should not allow you to update the finding\'s visibility if it doesnt belong to you' do
          session[:user_id] = @user.id
          expect(article.visibility).to eq 'Only me'

          patch :update, permalink: article.to_param, article: { visibility: 'Public' }, format: :json
          assert_response :unauthorized
        end

        it 'should not allow you to update it to a non-enumerated visibility', :focus do
          session[:user_id] = @user.id
          expect(my_article.visibility).to eq 'Only me'

          patch :update, permalink: my_article.to_param, article: { visibility: 'xxx' }, format: :json
          # expect {
          #   patch :update, permalink: my_article.to_param, article: { visibility: 'xxx' }, format: :json
          # }.to raise_error ArgumentError
        end
      end
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