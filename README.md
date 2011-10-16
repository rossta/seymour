# Seymour

Feed me activities, Seymour, please!

Seymour is a library for distributing activity items to  Redis-backed activity feeds
in a Rails application.

# Install

In your Gemfile

    gem "seymour"

Or via command line

    gem install seymour


# Background

This library is based on the feed architecture used to distribute activity
items at [Weplay](http://weplay.com). Weplay supports activity distribution
to a variety feeds: user dashboards, game day comment pages, global points
leaders, etc. Each activity item represents a small snippet of action announcing
some "actor" said or did some action on or to some "subject." When activities
are distributed, their ids are appended to Redis-lists maintained by separate
activity feed classes. The html for each activity item is pre-rendered
in a background job. To render a user's dashboard activities, the activity
feed needs only to select the activities at the top of the list and output
the pre-rendered html for each item, reducing the extra includes and joins
needed in-process.

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
  audience :members,  :feed => "DashboardFeed"

  # define methods for the audiences
  delegate :team,     :to => :comment
  delegate :members,  :to => :team

  def comment
    subject
  end
end

team = Team.last
user = team.organizer
comment   = Comment.create!(:author => user, :team => team, :body => "Great game!")
activity  = CommentActivity.create!(:actor => comment.author, :subject => comment)

activity.distribute

```
In our example application, a team has many members, and a comment belongs
to a team and an author. Let's say we'd like to distribute a notification
as an activity item to team members when someone comments on the team page.
Each team member has their own dashboard activity feed where activity items
are rendered.

The `feed_me_seymour` class declaration sets up activity classes with the
ability to declare their `audience` and `distribute` to audience feeds.
Activities can have any number of audiences. In this example, a comment
activity is created with the comment as its subject. At some point, perhaps
in a background job, we distribute the activity to the team and dashboard
feeds.

``` ruby
class TeamFeed < Seymour::ActivityFeed
end

class DashboardFeed < Seymour::ActivityFeed
end
```
When the activity is distributed, its id will be added to Redis-backed lists
represented by the audience feeds. For this example, Seymour expects to find
the TeamFeed and DashboardFeed classes when the activity is distributed.