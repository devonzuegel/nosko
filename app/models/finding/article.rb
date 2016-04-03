module Finding
  class Article < ActiveRecord::Base
    include Finding::Findable

    belongs_to :user,          dependent: :destroy
    has_one    :evernote_note, dependent: :destroy

    private

    REQUIRED_FIELDS = %i(content)
  end
end

