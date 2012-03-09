module Merit
  extend ActiveSupport::Concern

  module ClassMethods
    def has_merit(options = {})
      belongs_to :sash

      if Merit.orm == :mongo_mapper
        plugin Merit
        key :sash_id, String
        key :points, Integer, :default => 0
      end
    end
  end

  def badges
    create_sash_if_none
    Badge.find_by_id(sash.badge_ids).to_a
  end

  # Create sash if doesn't have
  def create_sash_if_none
    if sash.nil?
      self.sash = Sash.new
      self.save(:validate => false)
    end
  end
end

ActiveRecord::Base.send :include, Merit if Object.const_defined?('ActiveRecord')
MongoMapper::Document.plugin Merit if Object.const_defined?('MongoMapper')
