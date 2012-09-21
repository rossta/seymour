FactoryGirl.define do
  factory :user do |f|
    f.name "Bob"
  end

  factory :comment do |f|
    f.author { FactoryGirl.create(:user) }
  end

  factory :test_activity do |f|
    f.actor { FactoryGirl.create(:user) }
  end
end
