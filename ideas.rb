# 1- Ir llenando una tabla "acciones" del estilo de:
# _______________________________________________
# source (user_id) | action (method, value) | target (model, id)
# 1 | comment nil | List 8
# 1 | vote 3      | List 12
# 3 | follow nil  | User 1
# X | create nil  | User nil # se registra un usuario, X es el id generado
# _______________________________________________
# 
# Se define las acciones a trackear en los controladores, por ejemplo:
# class UsersController < ApplicationController
#   grant_badges :only => %w(create follow)
# end
# 
# La gema también crearía una tabla Badges, más o menos como sigue:
# ___________________
# id | name | level | image
# 1 | creador | inspirado | creador-inspirado.png
# 2 | creador | blogger   | creador-blogger.png
# 2 | creador | best-seller | creador-bestseller.png
# ___________________
#
#
# 2- La interfaz para especificar desde la aplicación cuándo aplicar cada badge
# sería un archivo tipo el ability.rb de cancan, que estaría en
# app/models/talent.rb, con una sintaxis tipo:
# 
# grant_on 'users#create', :badge => 'just', :level => 'registered' do
#   # Code block
# end
# 
# Donde el procedimiento es un método que chequea la lógica necesaria para dar
# ese badge, y evalúa a boolean. Obviamente tiene que saber de qué objetos
# estamos hablando (qué user y qué lista, por ejemplo), cabo que por ahora no
# queda atado.
#
#
# 3- Luego, podemos ir chequeando esas condiciones sincronizadamente, o
# mediante un proceso en background, por ejemplo cada 5 minutos, guardando
# hasta qué entrada de la primera tabla se procesó la vez anterior.


# ========== Posible sintaxis ==========

# app/models/talent.rb (onda cancan)
class Talent
  include Talent::Badges

  def initialize(user)
    user ||= User.new

    grant_on 'users#create', :badge => 'just', :level => 'registered' do
      true
    end

    grant_on 'comments#create', :badge => 'commenter', :level => 10 do
      current_user.comments.count == 10
    end
  end
end

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  grant_badges :only => %w(index create edit)
end


# ========== Tests ==========
u = User.first
u.badges
c = Comment.new{ :user_id = u.id }
c.save
u.badges

u = User.first
u.badges
TalentRules.new(u) # Not loading all rules (?)
include Talent::Rules
check_new_actions
u.badges


# ========== URLs ==========
# http://www.cowboycoded.com/2011/01/31/developing-is_able-or-acts_as-plugins-for-rails/
# http://www.stubbleblog.com/index.php/2011/04/writing-rails-engines-getting-started/
# https://gist.github.com/af7e572c2dc973add221
# http://www.themodestrubyist.com/2010/03/01/rails-3-plugins---part-1---the-big-picture/
# http://www.themodestrubyist.com/2010/03/05/rails-3-plugins---part-2---writing-an-engine/
# http://www.themodestrubyist.com/2010/03/16/rails-3-plugins---part-3---rake-tasks-generators-initializers-oh-my/
# https://github.com/krschacht/rails_3_engine_demo

https://github.com/dcadenas/state_pattern
https://github.com/rubyist/aasm
