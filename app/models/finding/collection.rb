module Finding
  class Collection
    TYPES = {
      article: Finding::Article
    }

    def initialize(user)
      @user = user
    end

    def all
      retrieve_records(user: @user)
    end

    def public
      retrieve_records(user: @user, visibility: visibility_to_enum('Public'))
    end

    def only_me
      retrieve_records(user: @user, visibility: visibility_to_enum('Only me'))
    end

    def friends
      retrieve_records(user: @user, visibility: visibility_to_enum('Friends'))
    end

    private

    def retrieve_records(query)
      TYPES.each.map { |_, klass| klass.where(query).order(created_at: :desc).limit(10) }.flatten
    end

    def visibility_to_enum(visibility_str)
      Shareable::SHARE_BY_DEFAULT_ENUM[ visibility_str ]
    end
  end
end