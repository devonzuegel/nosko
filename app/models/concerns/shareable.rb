module Shareable
  extend ActiveSupport::Concern

  SHARE_BY_DEFAULT_ENUM = { 'Only me' => 0, 'Friends' => 1, 'Public' => 2 }

  private

end