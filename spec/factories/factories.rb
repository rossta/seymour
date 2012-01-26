FactoryGirl.define do
  factory :user do |f|
    f.name "Bob"
  end

  factory :comment do |f|
    f.author { Factory(:user) }
  end

  factory :test_activity do |f|
    f.actor { Factory(:user) }
  end
end

