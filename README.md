# Seymour

Feed me activities, Seymour, please!

Seymour is a library for building Redis-backed activity feeds and distribution for a Rails application.

# Install

In your Gemfile

    gem "seymour"

Or via command line

    gem install seymour

# Synopsis



# Example

``` ruby
class Comment
  belongs_to  :team
  has_many    :members, :through => :memberships
end

class Activity
  feed_me_seymour     # acts_as_activity also works here

  belongs_to :actor
  belongs_to :subject, :polymorphic => true
end

class CommentActivity < Activity
  audience :team      # distributes to TeamFeed by default
  audience :members,  :feed_name => "DashboardFeed"

  # define methods for the audiences
  delegate :team,     :to => :comment
  delegate :members,  :to => :team

  def comment
    subject
  end

end

class TeamFeed < Seymour::ActivityFeed
end

class DashboardFeed < Seymour::ActivityFeed
end

team = Team.last
user = team.organizer
comment = Comment.create!(:author => user, :body => "Welcome to the team!")
activity = CommentActivity.create!(:actor => comment.author, :subject => comment)
activity.distribute

```
In our  example application, a blog post has many followers, and a comment
has belongs to a blog post and an author. Let's say we'd like to distribute
a notification as an activity item to team members when someone comments on
the team page. Each team member has their own dashboard activity feed where
activity items are rendered.

The `feed_me_seymour` class declaration sets up activity classes with the
ability to declare their `audience` and `distribute` to audience feeds.
Activities can have any number of audiences. In this example, a comment
activity is created with the comment as its subject. At some point, perhaps
in a background job, we distribute the activity. Based on the audience
declarations, Seymour expects a TeamFeed and a DashboardFeed class to be
defined.
