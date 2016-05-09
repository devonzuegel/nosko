describe FindingsController do
  before(:all) do
    @user     = create(:user)
    @friend   = create(:user)
    @stranger = create(:user)

    @article = create(:article, user: @stranger)
  end

  describe 'GET /finding/:permalink => #show' do
    describe 'when not signed in' do
      it 'should surface a public finding' do
        get :show, permalink: @article.permalink.path
        ap response.status
        ap JSON.parse(response.body)
      end

      it 'should not surface a person\'s friend-only finding'
      it 'should not surface a private finding'
      it 'should return a 404 when given an invalid permalink'
    end

    describe 'when signed in' do
      it 'should surface a public finding'
      it 'should surface a friend\'s friend-only finding'
      it 'should not surface a stranger\'s friend-only finding'
      it 'should not surface a private finding'
      it 'should return a 404 when given an invalid permalink'
    end
  end
end