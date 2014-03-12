# Place orm-dependent test preparation here
class ActiveSupport::TestCase
  setup do
    Mongoid.purge!
  end
end