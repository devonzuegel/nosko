class ProfileFeed
  DEFAULT_OPTIONS = Feed::DEFAULT_OPTIONS

  def initialize(user, viewer, options = {})
    @user    = user
    @viewer  = viewer
    @options = DEFAULT_OPTIONS.merge(options)
  end

  def findings
    result = Finding::Collection.new(@user).public
    # if @user.friends_with(@viewer)
    #   result += Finding::Collection.new(@user).friends
    # end
    if @user == @viewer
      result += Finding::Collection.new(@user).only_me
    end
    sorted(result.uniq)
  end

  private

  def sorted(list)
    result = list.sort_by(&@options.fetch(:order))
    return result.reverse if @options.fetch(:reverse)
    result
  end
end
