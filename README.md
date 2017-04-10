# Merit

Merit adds reputation behavior to Rails apps in the form of Badges, Points,
and Rankings.

[![Build Status](https://travis-ci.org/merit-gem/merit.svg?branch=master)](http://travis-ci.org/merit-gem/merit)
[![Coverage Status](https://coveralls.io/repos/github/merit-gem/merit/badge.svg?branch=master)](https://coveralls.io/github/merit-gem/merit?branch=master)
[![Code Climate](https://codeclimate.com/github/tute/merit/badges/gpa.svg)](https://codeclimate.com/github/tute/merit)

# Table of Contents

- [Installation](#installation)
- [Badges](#badges)
    - [Creating Badges](#creating-badges)
        - [Example](#example)
    - [Defining Rules](#defining-rules)
        - [Examples](#examples)
    - [Other Actions](#other-actions)
    - [Displaying Badges](#displaying-badges)
- [Points](#points)
    - [Defining Rules](#defining-rules-1)
        - [Examples](#examples-1)
    - [Other Actions](#other-actions-1)
    - [Displaying Points](#displaying-points)
- [Rankings](#rankings)
    - [Defining Rules](#defining-rules-2)
        - [Examples](#examples-2)
    - [Displaying Rankings](#displaying-rankings)
- [How merit finds the target object](#how-merit-finds-the-target-object)
- [Getting Notifications](#getting-notifications)
- [I18n](#i18n)
- [Uninstalling Merit](#uninstalling-merit)


# Installation

1. Add `gem 'merit'` to your `Gemfile`
2. Run `rails g merit:install`. This creates several migrations.
3. Run `rails g merit MODEL_NAME` (e.g. `user`). This creates a migration and adds `has_merit` to MODEL_NAME.
4. Run `rake db:migrate`
5. Define badges in `config/initializers/merit.rb`. You can also define ORM:
   `:active_record` (default) or `:mongoid`.
6. Configure reputation rules for your application in `app/models/merit/*`


# Badges

## Creating Badges

Create badges in `config/initializers/merit.rb`

`Merit::Badge.create!` takes a hash describing the badge:
* `:id` integer (required)
* `:name` this is how you reference the badge (required)
* `:level` (optional)
* `:description` (optional)
* `:custom_fields` hash of anything else you want associated with the badge (optional)

### Example

```ruby
Merit::Badge.create!(
  id: 1,
  name: "year-member",
  description: "Active member for a year",
  custom_fields: { difficulty: :silver }
)
```

## Defining Rules

Badges can be automatically given to any resource in your application based on
rules and conditions you create. Badges can also have levels, and be permanent
or temporary (A temporary badge is revoked when the conditions of the badge
are no longer met).

Badge rules / conditions are defined in `app/models/merit/badge_rules.rb`
`initialize` block by calling `grant_on` with the following parameters:

* `'controller#action'` a string similar to Rails routes (required)
* `:badge_id` or `:badge` these correspond to the `:id` or `:name` of the badge respectively
* `:level` corresponds to the `:level` of the badge
* `:to` the object's field to give the badge to. It needs a variable named
  `@model` in the associated controller action, like `@post` for
  `posts_controller.rb` or `@comment` for `comments_controller.rb`.
  * Can be a method name, which called over the target object should retrieve
    the object to badge. If it's `:user` for example, merit will internally
    call `@model.user` to find who to badge.
  * Can be `:itself`, in which case it badges the target object itself
    (`@model`).
  * Is `:action_user` by default, which means `current_user`.
* `:model_name` define the model's name if it's different from
  the controller's (e.g. the `User` model for the `RegistrationsController`).
* `:multiple` whether or not the badge may be granted multiple times. `false` by default.
* `:temporary` whether or not the badge should be revoked if the condition no
  longer holds. `false` -badges are kept for ever- by default.
* `&block` can be one of the following:
  * empty / not included: always grant the badge
  * a block which evaluates to boolean. It recieves the target object as
    parameter (e.g. `@post` if you're working with a PostsController action).
  * a block with a hash composed of methods to run on the target object and
    expected method return values

### Examples

```ruby
# app/models/merit/badge_rules.rb
grant_on 'comments#vote', badge_id: 5, to: :user do |comment|
  comment.votes.count == 5
end

grant_on ['users#create', 'users#update'], badge: 'autobiographer', temporary: true do |user|
  user.name? && user.email?
end
```

## Other Actions

```ruby
# Check granted badges
current_user.badges # Returns an array of badges

# Grant or remove manually
current_user.add_badge(badge.id)
current_user.rm_badge(badge.id)
```

```ruby
# Get related entries of a given badge
Merit::Badge.find(1).users
```

## Displaying Badges

Meritable models have a `badges` method which returns an array of associated
badges:

```erb
<ul>
  <% current_user.badges.each do |badge| %>
    <li><%= badge.name %></li>
  <% end %>
</ul>
```


# Points

## Defining Rules

Points are given to "meritable" resources on actions-triggered, either to the
action user or to the method(s) defined in the `:to` option. Define rules on
`app/models/merit/point_rules.rb`:

`score` accepts:

* `score`
  * `Integer`
  * `Proc`, or any object that accepts `call` which takes one argument, where
    the target object is passed in and the return value is used as the score.
* `:on` action as string or array of strings (like `controller#action`, similar to Rails routes)
* `:to` method(s) to send to the target object (who should be scored?)
* `:model_name` (optional) to specify the model name if it cannot be guessed
  from the controller. (e.g. `model_name: 'User'` for `RegistrationsController`,
  or `model_name: 'Comment'` for `Api::CommentsController`)
* `:category` (optional) to categorize earned points. `default` is used by default.
* `&block`
  * empty (always scores)
  * a block which evaluates to boolean (recieves target object as parameter)

### Examples

```ruby
# app/models/merit/point_rules.rb
score 10, to: :post_creator, on: 'comments#create', category: 'comment_activity' do |comment|
  comment.title.present?
end

score 20, on: [
  'comments#create',
  'photos#create'
]

score 15, on: 'reviews#create', to: [:reviewer, :reviewed]

proc = lambda { |photo| PhotoPointsCalculator.calculate_score_for(photo) }
score proc, on: 'photos#create'
```

## Other Actions

```ruby
# Score manually
current_user.add_points(20, category: 'Optional category')
current_user.subtract_points(10, category: 'Optional category')
```

```ruby
# Query awarded points since a given date
score_points = current_user.score_points(category: 'Optional category')
score_points.where("created_at > '#{1.month.ago}'").sum(:num_points)
```

## Displaying Points

Meritable models have a `points` method which returns an integer:

```erb
<%= current_user.points(category: 'Optional category') %>
```

If `category` left empty, it will return the sum of points for every category.

```erb
<%= current_user.points %>
```

# Rankings

A common ranking use case is 5 stars. They are not given at specified actions
like badges, a cron job should be defined to test if ranks are to be granted.

## Defining Rules

Define rules on `app/models/merit/rank_rules.rb`:

`set_rank` accepts:

* `:level` ranking level (greater is better, Lexicographical order)
* `:to` model or scope to check if new rankings apply
* `:level_name` attribute name (default is empty and results in
  '`level`' attribute, if set it's appended like
  '`level_#{level_name}`')

Check for rules on a rake task executed in background like:

```ruby
task cron: :environment do
  Merit::RankRules.new.check_rank_rules
end
```


### Examples

```ruby
set_rank level: 2, to: Committer.active do |committer|
  committer.branches > 1 && committer.followers >= 10
end

set_rank level: 3, to: Committer.active do |committer|
  committer.branches > 2 && committer.followers >= 20
end
```

## Displaying Rankings

```erb
<%= current_user.level %>
```


# How merit finds the target object

Merit fetches the rule’s target object (the parameter it receives) from its
`:model_name` option, or from the controller’s instance variable.

To read it from the controller merit searches for the instance variable named
after the singularized controller name. For example, a rule like:

```ruby
grant_on 'comments#update', badge_id: 1 do |target_object|
  # target_object would be better named comment in this sample
end
```

Would make merit try to find the `@comment` instance variable in the
`CommentsController#update` action. If the rule had the `:model_name` option
specified:

```ruby
grant_on 'comments#update', badge_id: 1, model_name: "Article" do |target_object|
  # target_object would be better named article in this sample
end
```

Merit would fetch the `Article` object from the database, found by the `:id`
param sent in that `update` action.

If none of these methods find the target, Merit will log a `no target_obj`
warning, with a comment to check the configuration for the rule.


# Getting Notifications

You can get observers notified any time merit changes reputation in your
application.

It needs to implement the `update` method, which receives as parameter the
following hash:

* `description`, describes what happened. For example: "granted 5 points",
  "granted just-registered badge", "removed autobiographer badge".
* `sash_id`, who saw it's reputation changed.
* `granted_at`, date and time when the reputation change took effect.

Example code (add your observer to `app/models` or `app/observers`):

```ruby
# reputation_change_observer.rb
class ReputationChangeObserver
  def update(changed_data)
    description = changed_data[:description]

    # If user is your meritable model, you can query for it doing:
    user = User.where(sash_id: changed_data[:sash_id]).first

    # When did it happened:
    datetime = changed_data[:granted_at]
  end
end
```
```ruby
# In `config/initializers/merit.rb`
config.add_observer 'ReputationChangeObserver'
```

# I18n

Merit uses default messages with I18n for notify alerts. To customize your app, you can set up your locale file:

```yaml
en:
  merit:
    granted_badge: "granted %{badge_name} badge"
    granted_points: "granted %{points} points"
    removed_badge: "removed %{badge_name} badge"
```

# Uninstalling Merit

1. Run `rails d merit:install`
2. Run `rails d merit MODEL_NAME` (e.g. `user`)
3. Run `rails g merit:remove MODEL_NAME` (e.g. `user`)
4. Run `rake db:migrate`
5. Remove `merit` from your Gemfile
