class EvernoteAccount < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true

  def expired?
    raise NotImplementedError
  end
end
