# Main Changes / Upgrading Notes

## 2.1.0

Adds serialisation of destroyed target models so that reputation can be awarded
when the item is already deleted from the DB. For this to work you need a new
column, to add it you can run:

```
rails generate merit:upgrade
rake db:migrate
```

This is a backwards compatible addition, so if you don't add the column but
upgrade, your application should continue to work well, without the new feature.

## 2.0.0

* Removes deprecated methods: `Merit::Badge.last_granted` and
  `Merit::Score.top_scored`.
* Removes `add_points` `log` parameter.
* Adds points category option.

## 1.9.0

* Deprecates `Merit::Badge.last_granted` and `Merit::Score.top_scored`.
  Code can be readded to client applications following instructions in:
  https://github.com/tute/merit/wiki/How-to-show-a-points-leaderboard
  https://github.com/tute/merit/wiki/How-to-show-last-granted-badges
* Deprecates `add_points` `log` parameter.

## 1.8.0

* Completes implementation of observer patter for getting reputation grant
  notifications to the client app. See: https://github.com/tute/merit#getting-
  notifications.
* Work on mongoid adapter (not yet ready), and other internals polishing.

## 1.7.0

* Adds support for dynamic scoring
* `substract_points` is deprecated in favor of `subtract_points`. Careless
  computers didn't mind my misspellings. ;-)
* JRuby and Rubinius compatibility

## 1.6.0

* Rails 4 ready.
* Adds ability to wildcard controllers like:
```ruby
grant_on '.*search#index', badge: 'searcher', multiple: true
```
* Allows custom fields to be defined on badges [97c998f]. Example:
  Merit::Badge.create!({
    id: 1,
    name: 'best-unicorn',
    custom_fields: { category: 'fantasy' }
  })

## 1.5.0

* Adds `Merit::ActivityLog` join model between `Merit::Action` and
  `Merit::BadgesSash` and `Merit::Score::Point` for logging purposes. Every
  time a badge is granted or removed, or points are changed, a new
  `ActivityLog` object gets created.
* Namespaces `Badge`, `Sash` and `BadgesSash` into `Merit` module. If your app
  uses any of those class names, you should add a `Merit::` prefix.
* Removes undocumented `log:string` column from `merit_actions`.

Run the following migration to upgrade from 1.4.0:

```ruby
class UpgradeMeritTo150 < ActiveRecord::Migration
  def self.up
    remove_column :merit_actions, :log
    create_table "merit_activity_logs", :force => true do |t|
      t.integer  "action_id"
      t.string   "related_change_type"
      t.integer  "related_change_id"
      t.string   "description"
      t.datetime "created_at"
    end
  end
end
```

## 1.4.0

* Removed `BadgesSash#set_notified!` undocumented method from code base.
* `:to` option for points and badges granting may now return an array of
  objects. For instance:

```ruby
# All user's comments earn points
score 2, to: :user_comments, on: 'comments#vote'
```

## to 1.3.0

Adds two methods meant to display a leaderboard.

* `Badge.last_granted(options = {})`. Accepts options:
  * `:since_date` (`1.month.ago` by default)
  * `:limit` (10 by default).

  It lists last 10 badge grants in the last month, unless you change query
  parameters.

* `Merit::Score.top_scored(options = {})`. Accepts options:
  * `:table_name` (`users` by default)
  * `:since_date` (`1.month.ago` by default)
  * `:limit` (10 by default).

  It lists top 10 scored objects in the last month, unless you change query
  parameters.

## to 1.2.0

* `Badge#grant_to(meritable_object)` no longer exists. Use
  `meritable_object.add_badge(badge_id)` (may add badges more than once).
* `Badge#delete_from(meritable_object)` no longer exists. Use
  `meritable_object.rm_badge(badge_id)`.

## to 1.1.0

Code refactorings. Support for Ruby 1.8.7 has been dropped.

## to 1.0.1

Adds `Merit::Point#created_at` (`merit_score_points` table) attribute.
May already be added if upgrading from merit < 1).

## to 1.0.0

Points granting history is now logged.

* Attribute `points` and method `points=` don't exist anymore (method `points`
  still works for querying number of points for a resource).
* There are new methods `add_points(num_points, log_message)` and
  `remove_points(num_points, log_message)` in meritable resources to manually
  change their amount of points, keeping a history log.

Run the following migration to have the new DB tables:

    class UpgradeMerit < ActiveRecord::Migration
      def self.up
        create_table :merit_scores do |t|
          t.references :sash
          t.string :category, :default => 'default'
        end

        create_table :merit_score_points do |t|
          t.references :score
          t.integer :num_points, :default => 0
          t.string :log
          t.datetime :created_at
        end
      end

      def self.down
        drop_table :merit_scores
        drop_table :merit_score_points
      end
    end

    # This will create a single point entry log, with previous points granted
    # to each meritable resource. Code example for a User class.

    class UpgradeMeritableResources < ActiveRecord::Migration
      def up
        User.find_each do |user|
          unless user.sash
            user.sash = Sash.create!
            user.save
          end

          user.sash.scores << Merit::Score.create
          user.add_points(user.read_attribute(:points), 'Initial merit points import.')
        end
        remove_column :users, :points
      end
    end

If you get an `ActiveRecord::DangerousAttributeError: points` exception, you
may need to temporarily tweak your meritable model, as explained in
http://stackoverflow.com/a/1515571/356060.


## to 0.10.0

`badges_sashes` table gets a primary key `id` column. Run the following migration:

    class AddIdToBadgesSashes < ActiveRecord::Migration
      def self.up
        add_column :badges_sashes, :id, :primary_key
      end

      def self.down
        remove_column :badges_sashes, :id
      end
    end

`set_notified!(badge = nil, sash = nil)` no longer exists, just call `set_notified!`
over the `badge_sash` object, with no parameters.

## to 0.9.0

Adds `allow_multiple` boolean option to `Badge#grant_to` (defaults to
`false`). If you used this method to grant a badge it will now grant only if
resource doesn't have the badge.

Use `badge.grant_to resource, :allow_multiple => true` where needed.

## to 0.8.0

No changes needed. Adds Mongoid support.

## to 0.7.0

No changes needed. Adds `:multiple` boolean option to `grant_on` to grant
badge multiple times.

## to 0.6.0

<tt>MeritBadgeRules</tt>, <tt>MeritPointRules</tt> and <tt>MeritRankRules</tt>
are now namespaced into Merit module. Move and change:

<pre>
app/models/merit_{badge|point|rank}_rules.rb -> app/models/merit/{badge|point|rank}_rules.rb
</pre>
<pre>
-class Merit{Badge|Point|Rank}Rules
-  include Merit::{Badge|Point|Rank}Rules
+module Merit
+  class {Badge|Point|Rank}Rules
+  include Merit::{Badge|Point|Rank}RulesMethods
</pre>

## to 0.5.0

Add <tt>log:string</tt> column to <tt>merit_actions</tt> table.

## to 0.4.0

Rankings are now integer attributes (<tt>level</tt>), they are not badges
anymore. <tt>set_rank</tt> doesn't accept <tt>badge_name</tt> anymore.

## to 0.3.0

Badges data is now stored in <tt>config/initializers/merit.rb</tt> using
<tt>ambry</tt> syntax (not in the DB anymore, as that table needed to be in
sync in all development environments).

## to 0.2.0

Added <tt>had_errors</tt> boolean attribute to <tt>merit_actions</tt> table.
