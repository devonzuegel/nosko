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
      retrieve_records(user: @user, visibility: 'Public')
    end

    def only_me
      retrieve_records(user: @user, visibility: 'Only me')
    end

    def friends
      retrieve_records(user: @user, visibility: 'friends')
    end

    def retrieve_records(query)
      TYPES.each.map { |_, klass| klass.where(query) }.flatten
    end
  end
end