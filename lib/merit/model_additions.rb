module Merit
  extend ActiveSupport::Concern

  module ClassMethods
    def has_merit(options = {})
      # MeritableModel#sash_id is more stable than Sash#meritable_model_id
      # That's why MeritableModel belongs_to Sash. Can't use
      # dependent: destroy as it may raise FK constraint exceptions. See:
      # https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/1079-belongs_to-dependent-destroy-should-destroy-self-before-assocation
      belongs_to :sash, class_name: 'Merit::Sash', inverse_of: nil, optional: true

      send :"_merit_#{Merit.orm}_specific_config"
      _merit_delegate_methods_to_sash
      _merit_define_badge_related_entries_method
      _merit_sash_initializer
    end

    # Delegate methods from meritable models to their sash
    def _merit_delegate_methods_to_sash
      methods = %w(badge_ids badges points add_badge rm_badge
                   add_points subtract_points score_points)
      methods.each { |method| delegate method, to: :_sash }
    end

    def _merit_active_record_specific_config
    end

    def _merit_mongoid_specific_config
      field :level, type: Integer, default: 0
      def find_by_id(id)
        where(_id: id).first
      end
    end

    def _merit_define_badge_related_entries_method
      meritable_class_name = name.demodulize
      Merit::Badge._define_related_entries_method(meritable_class_name)
    end

    # _sash initializes a sash if doesn't have one yet.
    # From Rails 3.2 we can override association methods to do so
    # transparently, but merit supports Rails ~> 3.0.0. See:
    # http://blog.hasmanythrough.com/2012/1/20/modularized-association-methods-in-rails-3-2
    def _merit_sash_initializer
      define_method(:_sash) do
        # TODO: reload.sash is not regression tested
        sash || reload.sash || update(sash: Sash.create)
        sash
      end
    end
  end
end
