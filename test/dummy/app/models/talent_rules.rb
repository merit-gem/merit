class TalentRules
  include Talent::Rules

  def initialize(user)
    user ||= User.new

    # TODO: Quien ejecuta esta acción se lleva la medalla. Es un ejemplo para
    # chequear en el método del controlador, para tener acceso al id generado.
    grant_on 'users#create', :badge => 'just', :level => 'registered' do
      true
    end

    grant_on 'comments#create', :badge => 'commenter', :level => 10 do
      user.comments.count == 10
    end

    grant_on 'comments#create', :badge => 'commenter', :level => 20 do
      user.comments.count == 20
    end

    check_new_actions # FIXME: Should be called somewhere else?
  end
end