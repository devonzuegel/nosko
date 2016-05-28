describe ProfileFeed do
  it 'should have the expected default options' do
    expect(ProfileFeed::DEFAULT_OPTIONS).to eq Feed::DEFAULT_OPTIONS
  end

  context '#findings' do
    before do
      @user     = create(:user)
      @leader   = create(:user)
      @stranger = create(:user)

      @user.follow!(@leader)

      visibilities = Shareable::SHARE_BY_DEFAULT_ENUM.keys.map { |k| k.downcase.tr(' ', '_').to_sym }
      [@user, @leader, @stranger].each do |u|
        visibilities.each { |t| create(:article, t, user: u) }
      end
    end

    it 'the before block should set things up as expected' do
      expect(Finding::Article.count).to eq 9
      expect(@user.leaders).to match [@leader]
    end

    it 'should surface all findings owned by @leader viewable to the non-friend follower in expected order' do
      expected_findings = Finding::Collection.new(@leader).public.sort_by &:created_at
      expect(ProfileFeed.new(@leader, @user).findings).to eq expected_findings
    end

    it 'should reverse findings result when passed reverse:true' do
      expected_findings = Finding::Collection.new(@leader).public.sort_by(&:created_at).reverse
      expect(ProfileFeed.new(@leader, @user, reverse: true).findings).to eq expected_findings
    end

    it 'needs to incorporate friends\' friend-only findings once that is implemented'

    it 'should perform LIMIT and OFFSET for pagination'
  end
end
