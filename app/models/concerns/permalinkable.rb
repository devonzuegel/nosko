module Permalinkable
  extend ActiveSupport::Concern

  module ClassMethods
  end

  module InstanceMethods
    private
    def generate_permalink
      puts "\n\n\n\nHELLOOOO\n\n\n"
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end