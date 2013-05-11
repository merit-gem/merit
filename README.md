# Merit
## Reputation Gem (Badges, Points, and Rankings) for Rails Applications


![Merit gem](http://i567.photobucket.com/albums/ss118/DeuceBigglebags/th_nspot26_300.jpg)

[![Build Status](https://travis-ci.org/tute/merit.png?branch=master)](http://travis-ci.org/tute/merit)
[![Code Climate](https://codeclimate.com/github/tute/merit.png)](https://codeclimate.com/github/tute/merit)

# Installation

1. Add `gem 'merit'` to your `Gemfile`
2. Run `rails g merit:install`
3. Run `rails g merit MODEL_NAME` (e.g. `user`)
4. Run `rake db:migrate`
5. Define badges in `config/initializers/merit.rb`
6. Configure reputation rules for your application in `app/models/merit/*`

---

# Badges
## Creating Badges
Create badges in `config/initializers/merit.rb`

`Merit::Badge.create!` takes a hash describing the badge:
* `:id` integer (reqired)
* `:name` this is how you reference the badge (required)
* `:level` (optional)
* `:image` (optional)
* `:description` (optional)
* `:custom_fields` hash of anything else you want associated with the badge (optional)

### Example
```ruby
Merit::Badge.create! ({
  id: 1,
  name: "Yearling",
  description: "Active member for a year",
  custom_fields: { dificulty: :silver }
})
```

## Defining Badge Rules
Badges can be automatically given to any resource in your application based on rules and conditions you create.
Badges can also have levels, and be temporary. 

Badge rules / conditions are defined in `app/models/merit/badge_rules.rb` `initialize` block by calling `grant_on` with the following parameters:

* `'controller#action'` a string similar to Rails routes
* `:badge` corresponds to the `:name` of the badge
* `:level` corresponds to the `:level` of the badge
* `:to` the object's field to give the badge to
  * if you are putting badges on to users then this field is probably `:user`
  * Important: this requires a variable named `@model` in the associated conroller action. e.g. `@post` or `@comment`
    * how Merit finds which object you're looking for: `target_obj = instance_variable_get(:"@#{controller_name.singularize}")`
* `:model_name` define the controller's name if it's different from
  the model's (e.g. `RegistrationsController` for the `User` model). (string)
* `:multiple` whether or not the badge may be granted multiple times. `false` by default. (boolean)
* `:temporary` whether or not the badge should be revoked if the condition no longer holds. `false` (badges are kept for ever) by default. (boolean)
* `&block`
  * empty / not included (always grant the badge)
  * a block which evaluates to a boolean. It recieves the target object as the parameter (e.g. `@post` if you're working with a PostsController action).
  * a block with a hash composed of methods to run on the target object with
    expected resultant values

### Examples

```ruby
# app/models/merit/badge_rules.rb
grant_on 'comments#vote', badge: 'relevant-commenter', to: :user do |comment|
  comment.votes.count == 5
end

grant_on ['users#create', 'users#update'], badge: 'autobiographer', temporary: true do |user|
  user.name.present? && user.email.present?
end
```

## Other Badge Actions

```ruby
# Check granted badges
current_user.badges # Returns an array of badges

# Grant or remove manually
current_user.add_badge(badge.id) # badge's id
current_user.rm_badge(badge.id) # badge's id
```

```ruby
# List 10 badge grants in the last month
Badge.last_granted

# List 20 badge grants in the last week
Badge.last_granted(since_date: 1.week.ago, limit: 20)

# Get related entries of a given badge
Badge.find(1).users
```

---

# Defining point rules

Points are given to "meritable" resources on actions-triggered, either to the
action user or to the method(s) defined in the `:to` option. Define rules on
`app/models/merit/point_rules.rb`:

`score` accepts:

* `:on` action as string or array of strings (similar to Rails routes)
* `:to` method(s) to send to the target_object (who should be scored?)
* `&block`
  * empty (always scores)
  * a block which evaluates to boolean (recieves target object as parameter)

## Examples

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
```

```ruby
# Check awarded points
current_user.points # Returns an integer

# Score manually
current_user.add_points(20, 'Optional log message')
current_user.substract_points(10)
```

```ruby
# List top 10 scored users in the last month
Merit::Score.top_scored

# List top 25 scored lists in the last week
Merit::Score.top_scored(
  table_name: :lists,
  since_date: 1.week.ago,
  limit: 25
)
```

---

# Defining rank rules

5 stars is a common ranking use case. They are not given at specified actions
like badges, you should define a cron job to test if ranks are to be granted.

Define rules on `app/models/merit/rank_rules.rb`:

`set_rank` accepts:

* `:level` ranking level (greater is better)
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


## Examples

```ruby
set_rank level: 2, to: Committer.active do |committer|
  committer.branches > 1 && committer.followers >= 10
end

set_rank level: 3, to: Committer.active do |committer|
  committer.branches > 2 && committer.followers >= 20
end
```


# To-do list

* Move level from meritable model into Sash
* `ActivityLog` should replace `add_points` `log` parameter
* FIXMES and TODOS.
