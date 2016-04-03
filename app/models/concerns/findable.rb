module Findable
  extend ActiveSupport::Concern

  include Permalinkable, FormEditable

  REQUIRED_FIELDS = %i(title source_url user_id)

  included do
    before_save :clean_url, :save_user
  end

  def save_user
    user.save!
  end

  def clean_url
    self.source_url = self.source_url.sub %r{^https?:(\/\/|\\\\)(www\.)?}i, ''
  end

  module ClassMethods
    def all_fields
      self.column_names.map { |n| n.to_sym }
    end

    def visible_fields
      all_fields - hidden_fields
    end

    def required_fields
      REQUIRED_FIELDS + self::REQUIRED_FIELDS
    end

    def optional_fields
      fields - required_fields
    end

    def hidden_fields
      %i(id permalink_id created_at updated_at)
    end
  end
end