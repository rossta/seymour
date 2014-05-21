FactoryGirl.define do
  factory :user, aliases: [:actor, :author] do
    name "Bob"
  end

  factory :comment do
    author
  end

  factory :test_activity do
    actor
  end
end
