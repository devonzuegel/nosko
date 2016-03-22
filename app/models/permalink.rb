class Permalink < ActiveRecord::Base
  validates_uniqueness_of :path

  before_create :generate_permalink

  def generate_permalink
    self.path = generate_unique_path
  end

  def trashed?
    trashed
  end

  private

  def generate_unique_path
    while true
      hashed_time = "#{Time.now.hash}"
      return hashed_time if Permalink.where(path: hashed_time).empty?
    end
  end
end
