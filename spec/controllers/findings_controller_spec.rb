describe FindingsController do
  # before(:all) do
  #   @user     = create(:user)
  #   @friend   = create(:user)
  #   @stranger = create(:user)
  # end
  # let(:article) { create(:article) }

  it 'should surface a public finding', :focus do
    # article.reload
    get :show, format: :json
    ap response.body
    ap response.status
    # assert_response :success
  end

  # describe 'json format' do
  #   describe 'GET /finding/:permalink => #show' do
  #     describe 'when not signed in' do

  #       it 'should limit the attributes of the finding returned'

  #       it 'should not surface a person\'s friend-only finding'
  #       it 'should not surface a private finding'
  #       it 'should return a 404 when given an invalid permalink'
  #     end

  #     describe 'when signed in' do
  #       it 'should surface a public finding'
  #       it 'should surface a friend\'s friend-only finding'
  #       it 'should not surface a stranger\'s friend-only finding'
  #       it 'should not surface a private finding'
  #       it 'should return a 404 when given an invalid permalink'
  #     end

  #     it 'should handle other types of findings too (which havent yet been implemented)'
  #   end
  # end


  # describe 'html format' do
  #   describe 'GET /finding/:permalink => #show' do
  #     describe 'when not signed in' do
  #       it 'should surface a public finding'
  #       it 'should not surface a person\'s friend-only finding'
  #       it 'should not surface a private finding'
  #       it 'should return a 404 when given an invalid permalink'
  #     end

  #     describe 'when signed in' do
  #       it 'should surface a public finding'
  #       it 'should surface a friend\'s friend-only finding'
  #       it 'should not surface a stranger\'s friend-only finding'
  #       it 'should not surface a private finding'
  #       it 'should return a 404 when given an invalid permalink'
  #     end

  #     it 'should handle other types of findings too (which havent yet been implemented)'
  #   end
  # end
end