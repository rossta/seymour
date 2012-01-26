Factory.define :user do |f|
  f.name "Bob"
end

Factory.define :comment do |f|
  f.author { Factory(:user) }
end

Factory.define :test_activity do |f|
  f.actor { Factory(:user) }
end