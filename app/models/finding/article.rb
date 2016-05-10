module Finding
  class Article < ActiveRecord::Base
    include Finding::Findable

    def decorate
      Finding::ArticleDecorator.decorate(self)
    end

    private

    REQUIRED_FIELDS = %i(content)
  end
end

