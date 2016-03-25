class EvernoteAccount < ActiveRecord::Base
  has_many   :evernote_note, dependent: :destroy
  belongs_to :user
  validates  :user, presence: true

  def expired?
    raise NotImplementedError
  end
end
