class EventActivity < Activity

  acts_as_activity do
    feed :event
    feed :user, :class_name => "PlayerFeed"
  end

end