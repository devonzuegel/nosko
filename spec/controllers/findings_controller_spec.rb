describe FindingsController, :omniauth do
  describe 'GET /finding/:permalink' do
    describe 'when not signed in' do
      it 'should surface a public finding'
      it 'should not surface a person\'s friend-only finding'
      it 'should not surface a private finding'
    end

    describe 'when signed in' do
      it 'should surface a public finding'
      it 'should surface a friend\'s friend-only finding'
      it 'should not surface a stranger\'s friend-only finding'
      it 'should not surface a private finding'
    end
  end
end