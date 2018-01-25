# Releasing

1. Update `NEWS.md` to reflect the changes since last release.
1. Tag the release: `git tag vVERSION -a -s`. The tag message should contain the
   appropriate `NEWS.md` subsection.
1. Push changes: `git push --tags`
1. Build and publish to rubygems:
   ```bash
   gem build merit.gemspec
   gem push merit-*.gem
   ```

1. Add a new GitHub release:
   https://github.com/merit-gem/merit/releases/new?tag=vVERSION
1. Announce the new release, making sure to say "thank you" to the contributors
   who helped shape this version!
