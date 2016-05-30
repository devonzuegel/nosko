class Feed
  DEFAULT_OPTIONS = {
    order:      :created_at,
    reverse:    false,
    offset:     0,
    limit:      20
  }

  def initialize(user, options = {})
    @user    = user
    @options = DEFAULT_OPTIONS.merge(options)
  end

  def findings
    if @user == nil
      return rendered(Finding::Article.where(visibility: 'Public').limit(@options.fetch(:limit)))
    end
    raw = [*raw_own_findings, *raw_leaders_findings, *raw_friends_findings]
    rendered(raw.uniq)
  end

  def leaders_findings
    rendered(raw_leaders_findings)
  end

  def friends_findings
    rendered(raw_friends_findings)
  end

  def own_findings
    rendered(raw_own_findings)
  end

  private

  def raw_leaders_findings
    result = []
    @user.leaders.each do |leader|
      Finding::Collection.new(leader).public.each { |f| result << f }
    end
    result
  end

  def raw_friends_findings
    []  # TODO implement me; will surface friend's "public" + "friends" posts
  end

  def raw_own_findings
    Finding::Collection.new(@user).all
  end

  def sorted(list)
    result = list.sort_by(&@options.fetch(:order))
    return result.reverse if @options.fetch(:reverse)
    result
  end

  def rendered(list)
    sorted(list).map { |finding| finding.decorate.as_prop }
  end
end
