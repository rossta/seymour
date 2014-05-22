class Activity < ActiveRecord::Base
  include Seymour::HasAudience

  belongs_to :actor, :class_name => "User"
  belongs_to :subject, :polymorphic => true
end
