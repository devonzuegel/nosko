require 'rails_helper'

RSpec.describe Following, type: :model do
  it 'should not allow a user to double-follow another user'
  it 'should require both leader and follower to be defined'
end
