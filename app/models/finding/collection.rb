module Finding
  class Collection
    TYPES = {
      article: Finding::Article
    }

    def initialize(user)
      @user = user
    end

    def all
      TYPES.each.map do |type, klass|
        records = klass.where(user: @user)
        records.map { |finding| finding }
      end.flatten
    end
  end
end