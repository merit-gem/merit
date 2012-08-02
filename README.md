# Merit Gem: Reputation rules (badges, points and rankings) for Rails applications

![Merit](http://i567.photobucket.com/albums/ss118/DeuceBigglebags/th_nspot26_300.jpg)

[![Build Status](https://secure.travis-ci.org/tute/merit.png?branch=master)](http://travis-ci.org/tute/merit)

# Installation

1. Add `gem 'merit'` to your `Gemfile`
2. Run `rails g merit:install`
3. Run `rails g merit MODEL_NAME` (e.g. `user`)
4. Depending on your ORM
  * ActiveRecord: Run `rake db:migrate`
  * Mongoid: Set `config.orm = :mongoid` in `config/initializers/merit.rb`
5. Define badges you will use in `config/initializers/merit.rb`
6. Configure reputation rules for your application in `app/models/merit/*`

---

# Defining badge rules

You may give badges to any resource on your application if some condition
holds. Badges may have levels, and may be temporary. Define rules on
`app/models/merit_badge_rules.rb`:

`grant_on` accepts:

* `'controller#action'` string (similar to Rails routes)
* `:badge` for badge name
* `:level` for badge level
* `:to` method name over target_object which obtains object to badge
* `:model_name` (string) define controller's name if it differs from
  the model (like `RegistrationsController` for `User` model).
* `:multiple` (boolean) badge may be granted multiple times
* `:temporary` (boolean) if the receiver had the badge but the condition
  doesn't hold anymore, remove it. `false` by default (badges are kept
  forever).
* `&block`
  * empty (always grants)
  * a block which evaluates to boolean (recieves target object as parameter)
  * a block with a hash composed of methods to run on the target object with
    expected values

## Examples


```ruby
grant_on 'comments#vote', :badge => 'relevant-commenter', :to => :user do |comment|
  comment.votes.count == 5
end

grant_on ['users#create', 'users#update'], :badge => 'autobiographer', :temporary => true do |user|
  user.name.present? && user.address.present?
end
```

## Grant manually

You may also grant badges "by hand" (optionally multiple times):

```ruby
Badge.find(3).grant_to(current_user, :allow_multiple => true)
```

---

# Defining point rules

Points are a simple integer value which are given to "meritable" resources.
They are given on actions-triggered, either to the action user or to the
method(s) defined in the `:to` option. Define rules on
`app/models/merit_point_rules.rb`:

## Examples

```ruby
score 10, :to => :post_creator, :on => 'comments#create'

score 20, :on => [
  'comments#create',
  'photos#create'
]
```

`:to` method(s) work as in badge rules: they are sent to the target_object.
In the following example, after a review gets created both `review.reviewer`
and `review.reviewed` are granted 15 points:

```ruby
score 15, :on => 'reviews#create', :to => [:reviewer, :reviewed]
```

---

# Defining rank rules

5 stars is a common ranking use case. They are not given at specified actions
like badges, you should define a cron job to test if ranks are to be granted.

Define rules on `app/models/merit_rank_rules.rb`:

`set_rank` accepts:

* `:level` ranking level (greater is better)
* `:to` model or scope to check if new rankings apply
* `:level_name` attribute name (default is empty and results in
  '`level`' attribute, if set it's appended like
  '`level_#{level_name}`')

Check for rules on a rake task executed in background like:

```ruby
task :cron => :environment do
  Merit::RankRules.new.check_rank_rules
end
```


## Examples

```ruby
set_rank :level => 2, :to => Commiter.active do |commiter|
  commiter.branches > 1 && commiter.followers >= 10
end

set_rank :level => 3, :to => Commiter.active do |commiter|
  commiter.branches > 2 && commiter.followers >= 20
end
```

---

# To-do list

* add an error handler for inexistent badges.
* Should namespace app/models into Merit module.
* rescue ActiveRecord::... should depend on ORM used
* :value parameter (for star voting for example) should be configurable
  (depends on params[:value] on the controller).
* Make fixtures for integration testing (now creating objects on test file!).
* Rules should be cached? Calling *Rules.new more than once

---

# Contributors

* [Tute Costa](https://github.com/tute)
* [Juan Schwindt](https://github.com/jschwindt)
* [Eric Knudtson](https://github.com/ek) ([Chef Surfing](https://chefsurfing.com/))
* [A4bandas media](https://github.com/a4bandas)
