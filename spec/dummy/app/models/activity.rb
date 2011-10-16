class Activity < ActiveRecord::Base
  acts_as_activity
  belongs_to :actor, :class_name => "User"
  belongs_to :subject, :polymorphic => true
end
