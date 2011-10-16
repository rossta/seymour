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
  feed_me_seymour

  # acts_as_activity also works here

  belongs_to :actor
  belongs_to :subject, :polymorphic => true
end

class CommentActivity < Activity
  audience :team
  audience :members,  :feed_name => "DashboardFeed"

  delegate :team,     :to => :comment
  delegate :members,  :to => :team

  def comment
    subject
  end

end
```
In our  example application, a blog post has many followers, and a comment
has belongs to a blog post and an author. Let's say we'd like to distribute
a notification as an activity item to team members when someone comments on
the team page. Each team member has their own dashboard activity feed where
activity items are rendered.

The `feed_me_seymour` class declaration sets up activity classes with the
ability to declare their `audience`. Activities can have any number of
audiences. In this example, when a comment activity is created (the comment
as the subject of the activity) it will distribute to the team feed and to
the dashboard members

