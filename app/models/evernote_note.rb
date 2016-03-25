class EvernoteNote < ActiveRecord::Base
  belongs_to :evernote_account, dependent: :destroy
  validates  :evernote_account, presence: true

  def expired?
    raise NotImplementedError
  end
end
