class Activity < ActiveRecord::Base
  feed_me_seymour
  belongs_to :actor, :class_name => "User"
  belongs_to :subject, :polymorphic => true
end
