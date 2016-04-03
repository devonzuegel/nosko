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
      self.column_names.map { |n| n.to_sym }
    end

    def visible_fields
      all_fields - hidden_fields
    end

    def required_fields
      raise NotImplementedError
    end

    def optional_fields
      visible_fields - required_fields
    end

    def hidden_fields
      raise NotImplementedError
    end
  end
end