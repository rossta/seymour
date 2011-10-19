class Event < ActiveRecord::Base
  has_many :attendees, :class_name => "User"
  has_many :comments
end
