class Highlight < ActiveRecord::Base
  include Permalinkable

  belongs_to :article
end
