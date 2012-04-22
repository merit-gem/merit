# Upgrading

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
