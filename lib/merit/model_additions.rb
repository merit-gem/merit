module Merit
  extend ActiveSupport::Concern

  module ClassMethods
    def has_merit(options = {})
      # MeritableModel#sash_id is more stable than Sash#meritable_model_id
      # That's why MeritableModel belongs_to Sash. Can't use
      # dependent: destroy as it may raise FK constraint exceptions. See:
      # https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/1079-belongs_to-dependent-destroy-should-destroy-self-before-assocation
      belongs_to :sash, class_name: (Merit.orm == :active_record ? 'Merit::Sash' : 'Sash')

      _merit_orm_specific_config
      _merit_delegate_methods_to_sash
      _merit_define_badge_related_entries_method
      _merit_sash_initializer
    end

    # Delegate methods from meritable models to their sash
    def _merit_delegate_methods_to_sash
      methods = %w(badge_ids badges points
        add_badge rm_badge
        add_points substract_points subtract_points)
      methods.each { |method| delegate method, to: :_sash }
    end

    def _merit_orm_specific_config
      if Merit.orm == :mongo_mapper
        plugin Merit
        key :sash_id, String
        key :points, Integer, default: 0
        key :level, Integer, default: 0
      elsif Merit.orm == :mongoid
        field :level, type: Integer, default: 0
      end
    end

    def _merit_define_badge_related_entries_method
      meritable_class_name = name.demodulize
      Badge._define_related_entries_method(meritable_class_name)
    end

    # _sash initializes a sash if doesn't have one yet.
    # From Rails 3.2 we can override association methods to do so
    # transparently, but merit supports Rails ~> 3.0.0. See:
    # http://blog.hasmanythrough.com/2012/1/20/modularized-association-methods-in-rails-3-2
    def _merit_sash_initializer
      define_method(:_sash) do
        if Merit.orm == :active_record
          if sash.nil?
            self.update_attribute :sash_id, Sash.create.id
          end
          self.sash
        elsif Merit.orm == :mongoid
          if self.sash.nil?
            @sash = Sash.where(user_id: self.id).first_or_create
            self.update_attribute(:sash_id, @sash.id)
          end
          sash
        end
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
