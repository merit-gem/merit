# Merit Gem: Reputation rules (badges, points and rankings) for Rails applications

![Merit](http://i567.photobucket.com/albums/ss118/DeuceBigglebags/th_nspot26_300.jpg)

[![Build Status](https://secure.travis-ci.org/tute/merit.png?branch=master)](http://travis-ci.org/tute/merit)


# Installation

1. Add <tt>gem 'merit'</tt> to your Gemfile
2. Run <tt>rails g merit:install</tt>
3. Run <tt>rails g merit MODEL_NAME</tt>
4. Run <tt>rake db:migrate</tt>
5. Configure reputation rules for your application

---

# Defining badge rules

You may give badges to any resource on your application if some condition
holds. Badges may have levels, and may be temporary. Define rules on
<tt>app/models/merit_badge_rules.rb</tt>:

<tt>grant_on</tt> accepts:

* <tt>'controller#action'</tt> string (similar to Rails routes)
* <tt>:badge</tt> for badge name
* <tt>:level</tt> for badge level
* <tt>:to</tt> method name over target_object which obtains object to badge
* <tt>:model_name</tt> (string) define controller's name if it differs from
  the model (like <tt>RegistrationsController</tt> for <tt>User</tt> model).
* <tt>:temporary</tt> (boolean) if the receiver had the badge but the
  condition doesn't hold anymore, remove it. <tt>false</tt> by default (badges
  are kept forever).
* <tt>&block</tt>
  * empty (always grants)
  * a block which evaluates to boolean (recieves target object as parameter)
  * a block with a hash composed of methods to run on the target object with
    expected values

## Examples

    grant_on 'comments#vote', :badge => 'relevant-commenter', :to => :user do |comment|
      comment.votes.count == 5
    end

    grant_on ['users#create', 'users#update'], :badge => 'autobiographer', :temporary => true do |user|
      user.name.present? && user.address.present?
    end

## Grant manually

You may also grant badges "by hand":

    Badge.find(3).grant_to(current_user)

---

# Defining point rules

Points are a simple integer value which are given to "meritable" resources.
They are given on actions-triggered, either to the action user or to the
method(s) defined in the <tt>:to</tt> option. Define rules on
<tt>app/models/merit_point_rules.rb</tt>:

## Examples

    score 10, :on => [
      'users#update'
    ]

    score 15, :on => 'reviews#create', :to => [:reviewer, :reviewed]

    score 20, :on => [
      'comments#create',
      'photos#create'
    ]

---

# Defining rank rules

5 stars is a common ranking use case. They are not given at specified actions
like badges, you should define a cron job to test if ranks are to be granted.

Define rules on <tt>app/models/merit_rank_rules.rb</tt>:

<tt>set_rank</tt> accepts:

* <tt>:level</tt> ranking level (greater is better)
* <tt>:to</tt> model or scope to check if new rankings apply
* <tt>:level_name</tt> attribute name (default is empty and results in
  '<tt>level</tt>' attribute, if set it's appended like
  '<tt>level_#{level_name}</tt>')

Check for rules on a rake task executed in background like:

    task :cron => :environment do
      Merit::RankRules.new.check_rank_rules
    end


## Examples

    set_rank :level => 2, :to => Commiter.active do |commiter|
      commiter.branches > 1 && commiter.followers >= 10
    end

    set_rank :level => 3, :to => Commiter.active do |commiter|
      commiter.branches > 2 && commiter.followers >= 20
    end

---

# To-do list

* add an error handler for inexistent badges.
* rails g merit MODEL_NAME shouldn't create general migrations again.
* Abstract User (rule.rb#51 for instance) into a Merit option.
* Should namespace app/models into Merit module.
* rescue ActiveRecord::... should depend on ORM used (MongoMapper?)
* Why 1.8.7 tests are not passing?
* :value parameter (for star voting for example) should be configurable
  (depends on params[:value] on the controller).
* Make fixtures for integration testing (now creating objects on test file!).

---

# Contributors

* [Tute Costa](https://github.com/tute)
* [Juan Schwindt](https://github.com/jschwindt)
* [Eric Knudtson](https://github.com/ek)
* [A4bandas media](https://github.com/a4bandas)
