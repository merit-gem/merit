# Merit

Merit adds reputation behavior to Rails apps in the form of Badges, Points,
and Rankings.

[![Build Status](https://travis-ci.org/tute/merit.png?branch=master)](http://travis-ci.org/tute/merit)
[![Code Climate](https://codeclimate.com/github/tute/merit.png)](https://codeclimate.com/github/tute/merit)


# Table of Contents

- [Merit](#merit)
- [Table of Contents](#table-of-contents)
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
- [Uninstalling Merit](#uninstalling-merit)
- [To-do List](#to-do-list)


# Installation

1. Add `gem 'merit'` to your `Gemfile`
2. Run `rails g merit:install`
3. Run `rails g merit MODEL_NAME` (e.g. `user`)
4. Run `rake db:migrate`
5. Define badges in `config/initializers/merit.rb`
6. Configure reputation rules for your application in `app/models/merit/*`


# Badges

## Creating Badges

Create badges in `config/initializers/merit.rb`

`Merit::Badge.create!` takes a hash describing the badge:
* `:id` integer (reqired)
* `:name` this is how you reference the badge (required)
* `:level` (optional)
* `:description` (optional)
* `:custom_fields` hash of anything else you want associated with the badge (optional)

### Example

```ruby
Merit::Badge.create! ({
  id: 1,
  name: "Yearling",
  description: "Active member for a year",
  custom_fields: { difficulty: :silver }
})
```

## Defining Rules

Badges can be automatically given to any resource in your application based on
rules and conditions you create. Badges can also have levels, and be permanent
or temporary (A temporary badge is revoked when the conditions of the badge
are no longer met).

Badge rules / conditions are defined in `app/models/merit/badge_rules.rb`
`initialize` block by calling `grant_on` with the following parameters:

* `'controller#action'` a string similar to Rails routes
* `:badge` corresponds to the `:name` of the badge
* `:level` corresponds to the `:level` of the badge
* `:to` the object's field to give the badge to
  * If you are putting badges on the related user then this field is probably
    `:user`.
  * Needs a variable named `@model` in the associated controller action, like
    `@post` for `posts_controller.rb` or `@comment` for `comments_controller.rb`.
    Implementation note: Merit finds the object with following snippet:
    `instance_variable_get(:"@#{controller_name.singularize}")`.
* `:model_name` define the controller's name if it's different from
  the model's (e.g. `RegistrationsController` for the `User` model).
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
grant_on 'comments#vote', badge: 'relevant-commenter', to: :user do |comment|
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
# List 10 badge grants in the last month
Badge.last_granted

# List 20 badge grants in the last week
Badge.last_granted(since_date: 1.week.ago, limit: 20)

# Get related entries of a given badge
Badge.find(1).users
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
    the target_object is passed in and the return value is used as the score.
* `:on` action as string or array of strings (similar to Rails routes)
* `:to` method(s) to send to the target_object (who should be scored?)
* `:model_name` (optional) to specify the model name if it cannot be guessed
  from the controller. (e.g. `model_name: 'User'` for `RegistrationsController`,
  or `model_name: 'Comment'` for `Api::CommentsController`)
* `&block`
  * empty (always scores)
  * a block which evaluates to boolean (recieves target object as parameter)

### Examples

```ruby
# app/models/merit/point_rules.rb
score 10, to: :post_creator, on: 'comments#create' do |comment|
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
current_user.add_points(20, 'Optional log message')
current_user.subtract_points(10)
```

```ruby
# Query awarded points since a given date
score_points = current_user.sash.scores.first.score_points
score_points.where("created_at > '#{1.month.ago}'").sum(:num_points)

# List top 10 scored users in the last month
Merit::Score.top_scored

# List top 25 scored lists in the last week
Merit::Score.top_scored(
  table_name: :lists,
  since_date: 1.week.ago,
  limit: 25
)
```

## Displaying Points

Meritable models have a `points` method which returns an integer:

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


# Uninstalling Merit

1. Run `rails d merit:install`
2. Run `rails d merit MODEL_NAME` (e.g. `user`)
3. Run `rails g merit:remove MODEL_NAME` (e.g. `user`)
4. Run `rake db:migrate`
5. Remove `merit` from your Gemfile


# To-do List

* Finish Observer implementation for `Judge`.
* Move level from meritable model into Sash
* `ActivityLog` should replace `add_points` `log` parameter
* FIXMES and TODOS.
