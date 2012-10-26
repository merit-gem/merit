# Upgrading

## to 1.0.1

Adds Merit::Point#created_at attribute.

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
          user.sash.scores << Merit::Score.create
          user.add_points(user.points, 'Initial merit points import.')
        end
        remove_column :users, :points
      end
    end

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
