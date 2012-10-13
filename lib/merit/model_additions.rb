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

  # Delegate relationship methods from meritable models to their sash
  %w(badge_ids badges points).each do |method|
    define_method(method) do
      _sash = sash || create_sash_and_scores
      _sash.send method
    end
  end

  # Create sash if doesn't have
  def create_sash_and_scores
    if self.sash.blank?
      self.sash = Sash.create
      self.sash.scores << Merit::Score.create
      self.save(:validate => false)
    end
    self.sash
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
