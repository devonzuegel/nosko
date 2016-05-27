class Feed
  DEFAULT_OPTIONS = {
    order:      'created_at DESC',
    reverse:    false,
    offset:     0,
    limit:      20,
  }

  def initialize(user, options = {})
    @user    = user
    @options = DEFAULT_OPTIONS.merge(options)
  end

  def findings
    @user.findings
  end
end
