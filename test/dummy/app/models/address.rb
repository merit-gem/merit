case Merit.orm
when :active_record
  class Address < ActiveRecord::Base
  end
when :mongoid
  class Address
    include Mongoid::Document
    include Mongoid::Timestamps
  end
end

class Address
  belongs_to :user
end
