module Finding
  module Findable
    extend ActiveSupport::Concern

    include Permalinkable, FormEditable

    REQUIRED_FIELDS = %i(title source_url user_id)
    HIDDEN_FIELDS   = %i(id permalink_id created_at updated_at)

    included do
      belongs_to :user
      before_save :clean_url, :save_user
    end

    def save_user
      user.save!
    end

    def clean_url
      self.source_url = self.source_url.sub %r{^https?:(\/\/|\\\\)(www\.)?}i, ''
    end

    module ClassMethods
      def required_fields
        REQUIRED_FIELDS + self::REQUIRED_FIELDS
      end

      def hidden_fields
        HIDDEN_FIELDS + self::HIDDEN_FIELDS
      end
    end
  end
end