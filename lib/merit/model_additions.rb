module Merit
  extend ActiveSupport::Concern

  module ClassMethods
    def has_merit(options = {})
      # :dependent => destroy may raise
      # ERROR: update or delete on table "sashes" violates foreign key constraint "users_sash_id_fk"
      # https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/1079-belongs_to-dependent-destroy-should-destroy-self-before-assocation
      belongs_to :sash

      if Merit.orm == :mongo_mapper
        plugin Merit
        key :sash_id, String
        key :points, Integer, :default => 0
        key :level, Integer, :default => 0
      elsif Merit.orm == :mongoid
        field :sash_id
        field :points, :type => Integer, :default => 0
        field :level, :type => Integer, :default => 0
        def find_by_id(id)
          where(:_id => id).first
        end
      end
    end
  end

  def badges
    create_sash_if_none
    sash.badges
  end

  # Create sash if doesn't have
  def create_sash_if_none
    if self.sash.blank?
      self.sash = Sash.create
      self.save(:validate => false)
    end
  end
end

if Object.const_defined?('ActiveRecord')
  ActiveRecord::Base.send :include, Merit
end
if Object.const_defined?('MongoMapper')
  MongoMapper::Document.plugin Merit
end
if Object.const_defined?('Mongoid')
  Mongoid::Document.send :include, Merit
end
