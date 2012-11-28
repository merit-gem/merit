module Merit
  extend ActiveSupport::Concern

  module ClassMethods
    def has_merit(options = {})
      # MeritableModel#sash_id is more stable than Sash#meritable_model_id
      # That's why MeritableModel belongs_to Sash. Can't use
      # :dependent => destroy as it may raise FK constraint exceptions. See:
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

      # Delegate relationship methods from meritable models to their sash
      # _sash initializes a sash if doesn't have one yet.
      # From Rails 3.2 we can override association methods to do so
      # transparently, but merit supports Rails ~> 3.0.0. See:
      # http://blog.hasmanythrough.com/2012/1/20/modularized-association-methods-in-rails-3-2
      %w(badge_ids badges points add_points substract_points).each do |method|
        delegate method, to: :_sash
      end
      define_method(:_sash) do
        if sash.nil?
          self.sash = Sash.create
          self.save(:validate => false)
        end
        self.sash
      end
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
