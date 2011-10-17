# Seymour

Feed me activities, Seymour, please!

Seymour is a library for distributing activity items to  Redis-backed activity feeds
in a Rails application.

## Install

In your Gemfile

    gem "seymour"

Or via command line

    gem install seymour


## Overview

Seymour provides allows an application to distribute activities to a number of interested parties. A typical activity is a small snippet of announcing an "actor" performed some action, such as a comment activity in "Coach Bob commented 'Great game, yesterday'"

``` ruby
class Activity
  belongs_to :actor
  belongs_to :subject, :polymorphic => true

  feed_me_seymour     # acts_as_activity also works here
end

class CommentActivity < Activity
  audience :team      # distributes to TeamFeed by default
  audience :members,  :feed => "DashboardFeed"

  # define methods for the audiences
  delegate :team,     :to => :comment
  delegate :members,  :to => :team

  def comment
    self.subject
  end
end
```

Declaring `feed_me_seymour` in the activity parent class provides `Activity` and its subclasses with the ability to set their `audience`. Activities can have any number of audiences. Each audience must be available as an instance method on comment activities.

``` ruby
class TeamFeed < Seymour::ActivityFeed
end

class DashboardFeed < Seymour::ActivityFeed
end

```

At some point, perhaps in a background job, we distribute the activity to our audience. Instances of seymour-enabled classes have a `distribute` method, which adds the activity id to the front of Redis lists activity feeds for each audience member. Seymour expects to find the TeamFeed and DashboardFeed classes at distribution time. Other activities can distribute to the same feeds owned by the same audience members as well.

``` ruby
comment   = Comment.create! # 'Great game, yesterday'
activity  = CommentActivity.create!(:actor => comment.author, :subject => comment)

activity.distribute
```

## Background

This library is based on the feed architecture used to distribute activity items at [Weplay](http://weplay.com). Weplay supports activity distribution to a variety of feeds: user dashboards, game day comment pages, global points leaders, etc.

