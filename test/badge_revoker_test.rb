require 'test_helper'

describe Merit::BadgeRevoker do

  describe '#revoke' do
    it 'should remove the badge from the sash and log the action' do
      sash = OpenStruct.new
      badge = OpenStruct.new(id: 34)
      action = Merit::Action.new
      sash.expects(:rm_badge).with(34)
      action.expects(:log_activity).with('badge_removed:34')
      revoker = Merit::BadgeRevoker.new(sash, badge, action)
      revoker.revoke
    end
  end

end
