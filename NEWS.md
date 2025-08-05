# News

User-visible changes worth mentioning.

## 5.0.0

- Drop end-of-life'd rails versions: 5.2, 6.x, <7.2
- Drop end-of-life’d ruby versions 3.0, 3.1
- Test with current versions of Rails: 7.2, 8.0, and ruby >=3.2
- Fix warning: add observer as runtime dependency
- Mark 3 tests as pending to the open bug on deleted models
- Convert project to GitHub Actions

## 4.0.3

- Add webrick as a development dependency
- [#363] Fix: `warning: already initialized constant Merit::*` messages
- [#357] Fix `merit_actions` migration template

## 4.0.2

- [#355, #356] Add index on merit_actions.processed column
- [#354] Fix Rails autoloader deprecation warnings
  Requires wrapping `Merit::Badge.create` with `Rails.application.reloader.to_prepare`
- Test with Ruby 3 and Rails 6.1 (excludes Rails 5.2 with Ruby 3, that errors out)
- [#288] Don’t send “removed badge” notifications when user doesn’t have the badge

## 4.0.1

- [#351] Fix bug on generating migrations

## 4.0.0

- Stop testing on Rails 5.1
- Drop support for mongoid
- Drop v2 upgrade generators
- Enable Zeitwerk gem mode (and renames internal merit constants)

## 3.0.3

- Test against Ruby 2.6 and Rails 6
- Use `find_each` in favor of `map` in `Merit::Action.check_unprocessed`
- Allow finding badges defined with symbol names
- Remove `Badge#last_granted` method (deprecated in merit <2.0)

## 3.0.2

- [#287] Make Sash an optional dependency, fixing issues in Rails 5.1.
- [#297] Initialize merit once both for API or non-API apps
- Updates dependencies

## 3.0.1

- [#282] Run action controller load hook only once
- [#284] Add migration version to active record migrations
- Add RELEASING.md document

## 3.0.0

- [#276] Drops Rails <5 version support. Drops deprecated `action_filter` call.
- Fix deprecation warnings

## 2.4.0

- [#260] Works with Rails 5

## 2.3.4

- [#247] Fix Ruby warnings
- [#252] Bug fix: `uninitialized constant Merit::PointRules (NameError)` while
    installing merit.

## 2.3.3

- [#215] Bug fix in API where a `BadgeSash` would be created without failures
  with a nil `badge_id`.
- Add validations to `BadgesSash`
- Rename generated migration files to explicitly name merit
- README improvements

## 2.3.2

- [#218] Implement I18n for internationalization support
- Tests with Ruby 2.2. Ignores EOL Rails 4.0.
- Adds CONTRIBUTING document

## 2.3.1

- [#204] Sash creation bugfix on certain conditions
- [733da49] Improve examples and docs for points `on` option

## 2.3.0

- [#206] Allow Rule to find Badge by `badge_id`
- [#197] SVG badges in favor of PNG in the readme.
- [#195] migrations refactor
- Tests with Rails 4.2

## 2.2.0

- [#181] Rescue `ActiveRecord` only if constant is defined (doesn't trigger
  errors in other ORMs).
- [#184] Namespaces `Badge` calls inside of `Merit::`. Prevents errors if the
  app using merit has a model named Badge
- [#189] Fixes issue when objects needed to grant reputation are already deleted
  from the database. Before, merit was either failing with exceptions or
  ignoring reputation changes; now it works as expected.

## 2.1.2

- Improves observer API.

## 2.1.1

- [#158] Migrations bug fix.

## 2.1.0

- [#148] Mongoid support
- Docs, tests, internals polishing.

## 2.0.0

- [#146] Fixes loading paths
- [#140] Points Categories feature
- Removes deprecated methods

## 1.9.0

- [#134] Bug fix: find sashes only when rules apply.
- Adds deprecation warnings.

## 1.8.0

- [#128] Finishes Observer implementation so client applications can be
  notified when reputation changes.
- [#123] Work towards mongoid support. Still work in progress.

## 1.7.1

- [#121] Adds "Uninstall Merit" rake task.
- [#124] Thread safe configuration instance variable.
- [#133] Fixes Rails 4 + protected_attributes bug.
- Starts this Changelog!
