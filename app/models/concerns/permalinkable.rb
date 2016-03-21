module EvernoteParsable
  extend ActiveSupport::Concern

  module ClassMethods
  end

  module InstanceMethods
    private
    # constants go here
    #
    # methods available only within class go here
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end