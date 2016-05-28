class Feed
  DEFAULT_OPTIONS = {
    order:      :created_at,
    reverse:    false,
    offset:     0,
    limit:      20,
  }

  def initialize(user, options = {})
    @user    = user
    @options = DEFAULT_OPTIONS.merge(options)
  end

  def findings
    raw = [*own_findings, *leaders_findings, *friends_findings]
    sorted(raw.uniq)
  end

  def leaders_findings
    result = []
    @user.leaders.each do |leader|
      Finding::Collection.new(leader).public.each { |f| result << f }
    end
    sorted(result)
  end

  def friends_findings
    sorted([])  # TODO implement me; will surface friend's "public" + "friends" posts
  end

  def own_findings
    sorted(Finding::Collection.new(@user).all)
  end

  def sorted(list)
    result = list.sort_by(&@options.fetch(:order))
    return result.reverse if @options.fetch(:reverse)
    result
  end
end
