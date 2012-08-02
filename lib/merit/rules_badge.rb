module Merit
  # La configuración para especificar cuándo aplicar cada badge va en
  # app/models/merit_rules.rb, con la siguiente sintaxis:
  #
  #   grant_on 'users#create', :badge => 'just', :level => 'registered' do
  #     # Nothing, or code block which evaluates to boolean
  #   end
  #
  # También se puede asignar medallas desde métodos en controladores:
  #
  #   Badge.find(3).grant_to(current_user)
  #
  # Merit crea una tabla Badges similar a:
  #   ___________________________________________________
  #   id | name    | level       | image
  #   1  | creador | inspirado   | creador-inspirado.png
  #   2  | creador | blogger     | creador-blogger.png
  #   2  | creador | best-seller | creador-bestseller.png
  #   ___________________________________________________
  #
  # Y llena una tabla de acciones, del estilo de:
  #   ______________________________________________________________
  #   source (user_id) | action (method, value) | target (model, id) | processed
  #   1 | comment nil | List 8 | true
  #   1 | vote 3      | List 12 | true
  #   3 | follow nil  | User 1 | false
  #   X | create nil  | User #{generated_id} | false
  #   ______________________________________________________________
  #
  # Luego chequea las condiciones sincronizadamente, o mediante un proceso en
  # background, por ejemplo cada 5 minutos (Merit::BadgeRules#check_new_actions).
  module BadgeRulesMethods
    # Define rule for granting badges
    def grant_on(action, *args, &block)
      options = args.extract_options!

      actions = action.kind_of?(String) ? [action] : action

      rule = Rule.new
      rule.badge_name = options[:badge]
      rule.level      = options[:level]
      rule.to         = options[:to] || :action_user
      rule.multiple   = options[:multiple] || false
      rule.temporary  = options[:temporary] || false
      rule.model_name = options[:model_name] || actions[0].split('#')[0]
      rule.block      = block

      actions.each do |action|
        defined_rules[action] ||= []
        defined_rules[action] << rule
      end
    end

    # Check non processed actions and grant badges if applies
    def check_new_actions
      MeritAction.where(:processed => false).each do |merit_action|
        merit_action.check_rules
      end
    end

    # Currently defined rules
    def defined_rules
      @defined_rules ||= {}
    end
  end
end
