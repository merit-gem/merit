# Se define qué acciones "trackear" en los controladores, por ejemplo:
#   class UsersController < ApplicationController
#     grant_badges :only => %w(create follow)
#   end
#
# La configuración para especificar cuándo aplicar cada badge va en
# app/models/merit_rules.rb, con la siguiente sintaxis:
#
#   grant_on 'users#create', :badge => 'just', :level => 'registered' do
#     # Nothing, or code block which evaluates to true
#     # or with a { methods -> expected_values } hash.
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
# background, por ejemplo cada 5 minutos (Merit::Rules#check_new_actions).

require 'merit/core_extensions'
require 'merit/rule'
require 'merit/rules'
require 'merit/controller_additions'
require 'merit/model_additions'

module Merit
  # Check rules on each request
  mattr_accessor :checks_on_each_request
  @@checks_on_each_request = true

  # Load configuration from initializer
  def self.setup
    yield self
  end

  class Engine < Rails::Engine
  end
end