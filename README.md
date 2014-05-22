# Seymour

*Activities for those that care*. Seymour is a library for distributing activity items to Redis-backed activity feeds in a Rails application.

[![Build Status](https://secure.travis-ci.org/rossta/seymour.png)](http://travis-ci.org/rossta/seymour)


## Install

In your Gemfile

    gem "seymour"

Or via command line

    gem install seymour


## Overview

Let's say you want to display a list of activities, where an activity is something like "Coach Bob commented 'Great game, yesterday'". You may be using a gem like [public_activity](https://github.com/pokonski/public_activity) to generate activity items. 

Depending on the context, deciding which activities to display can be complicated to determine during the request. The set of people who care about Coach Bob's comment may include his players, the parents of those players and other fans of the team.

Seymour allows the application to distribute activities to "feeds" ahead of time, where a feed belongs to an interested party, like an individual profile or a team page.

## Usage

Activities can have any number of audiences. Each audience should be represented as instance method that returns a set of records (things with ids). For example, comment activities in a sports-themed application may look like the following.

``` ruby
class CommentActivity
  include Seymour::HasAudience
  
  # context
  belongs_to :author, class_name: 'User'
  belongs_to :subject, polymorphic: true

  # declare audiences
  audience :team      # distributes to TeamFeed by default
  audience :members,  :feed => "DashboardFeed"

  # define methods for `team` and `members`
  def team
    self.subject
  end
  
  def members
    team.members
  end 
end
```

Each audience must be backed by a feed, which is a class that inherits from `Seymour::Feed`. Add these classes to `app/models`, `app/feeds`, or wherever makes sense for your application.

``` ruby
class TeamFeed < Seymour::Feed
end

class DashboardFeed < Seymour::Feed
end

```

Call `#distribute` to send the activity to its audience(s). This will add the id of the activity to a Redis list associated with each audience feed.

```ruby
class CommentActivity
  # ...
  
  # deliver activity to audiences
  after_create :distribute
end
```

## Background

This library is based on the feed architecture used to distribute activity items at [Weplay](http://weplay.com). Weplay supports activity distribution to a variety of feeds: user dashboards, game day comment pages, global points leaders, etc. The html for each activity item is pre-rendered in a background job. To build a user's dashboard activities, the activity feed needs only to select the activities at the top of the list and output the pre-rendered html for each item, reducing the extra includes and joins needed in-process.

## TODO

* generator for activity model + migration
* generator for activity feed
* support rollup
* relevance/affinity sorting
