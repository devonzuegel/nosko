class ProfileFeed
  DEFAULT_OPTIONS = Feed::DEFAULT_OPTIONS

  def initialize(user, viewer, options = {})
    @user    = user
    @viewer  = viewer
    @options = DEFAULT_OPTIONS.merge(options)
  end

  def findings
    result = users_findings.public
    # if @user.friends_with(@viewer)
    #   result += users_findings.friends
    # end
    sorted(result.uniq)
  end

  private

  def users_findings
    @users_findings ||= Finding::Collection.new(@user)
  end

  def sorted(list)
    result = list.sort_by(&@options.fetch(:order))
    return result.reverse if @options.fetch(:reverse)
    result
  end
end
