module Finding
  module Findable
    extend ActiveSupport::Concern

    include Permalinkable, FormEditable, Shareable

    REQUIRED_FIELDS = %i(title user_id locked visibility)
    HIDDEN_FIELDS   = %i(id permalink_id created_at updated_at)

    included do
      belongs_to :user
      before_save :clean_url, :save_user
    end

    def locked?
      locked
    end

    def unlocked?
      !locked?
    end

    def lock!
      update(locked: true)
    end

    def unlock!
      update(locked: false)
    end

    def to_param
      permalink.path
    end

    def save_user
      user.save!
    end

    def clean_url
      if self.source_url
        self.source_url = self.source_url.sub %r{^https?:(\/\/|\\\\)(www\.)?}i, ''
      end
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