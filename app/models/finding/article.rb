module Finding
  class Article < ActiveRecord::Base
    include Finding::Findable

    private

    REQUIRED_FIELDS = %i(content)
  end
end

