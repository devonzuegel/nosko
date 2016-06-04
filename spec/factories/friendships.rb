FactoryGirl.define do
  factory :friendship do
    association :friender, factory: :user
    association :friendee, factory: :user
  end

end
