class Permalink < ActiveRecord::Base
  validates_uniqueness_of :path

  before_create :generate_path

  def trashed?
    trashed
  end

  private

  def generate_path
    if !self.path.nil?
      raise ArgumentError, "You cannot pre-define a Permalink path"
    end

    self.path = unique_path
  end

  def unique_path
    while true
      random_str = SecureRandom.urlsafe_base64
      return random_str if Permalink.where(path: random_str).empty?
    end
  end
end
