Factory.define :user do
end

Factory.define :comment do |f|
  f.author { Factory(:user) }
end

Factory.define :test_activity do |f|
  f.actor { Factory(:user) }
end