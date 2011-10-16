class Event < ActiveRecord::Base

  has_many :attendees, :class_name => "User"

end
