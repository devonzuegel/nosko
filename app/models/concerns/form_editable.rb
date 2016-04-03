module FormEditable
  extend ActiveSupport::Concern

  included do
    validate :validate_required_fields
  end

  def validate_required_fields
    self.class.required_fields.each do |field|
      errors.add(field, 'cannot be blank') if self[field].blank?
    end
  end

  module ClassMethods
    def all_fields
      raise NotImplementedError
    end

    def fields
      raise NotImplementedError
    end

    def required_fields
      raise NotImplementedError
    end

    def optional_fields
      raise NotImplementedError
    end

    def hidden_fields
      raise NotImplementedError
    end
  end
end