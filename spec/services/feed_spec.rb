describe Feed do
  it 'should have the expected default options' do
    expect(Feed::DEFAULT_OPTIONS).to eq ({
      order:      :created_at,
      reverse:    false,
      offset:     0,
      limit:      20,
    })
  end

  context '#findings' do
    before do
      @user     = create(:user)
      @leader   = create(:user)
      @stranger = create(:user)

      @user.follow!(@leader)

      Finding::Article.destroy_all
      visibilities = Shareable::SHARE_BY_DEFAULT_ENUM.keys.map { |k| k.downcase.tr(' ', '_').to_sym }
      [@user, @leader, @stranger].each do |u|
        visibilities.each { |t| create(:article, t, user: u) }
      end
    end

    it 'the before block should set things up as expected' do
      expect(Finding::Article.count).to eq 9
      expect(@user.leaders).to match [@leader]
    end

    it 'should surface all findings viewable to the user in expected order' do
      expected_findings = [
        *Finding::Collection.new(@user).all,
        *Finding::Collection.new(@leader).public
      ].sort_by &:created_at
      expect(Feed.new(@user).findings).to eq expected_findings
    end

    # TODO update me
    it 'should surface all findings viewable to the user owned by his/her friends' do
      expect(Feed.new(@user).friends_findings).to eq []
    end

    it 'should surface all findings viewable to the user owned by his/her leaders' do
      expect(Feed.new(@user).leaders_findings).to eq Finding::Collection.new(@leader).public
    end

    it 'should reverse findings result when passed reverse:true' do
      expected_findings = [
        *Finding::Collection.new(@user).all,
        *Finding::Collection.new(@leader).public
      ].sort_by(&:created_at).reverse
      expect(Feed.new(@user, reverse: true).findings).to eq expected_findings
    end

    it 'needs to incorporate friends\' friend-only findings once that is implemented'

    it 'should perform LIMIT and OFFSET for pagination'
  end
end
