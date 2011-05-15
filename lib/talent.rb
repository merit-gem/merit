# 1- Llena una tabla "acciones" del estilo de:
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
# 2- Crea una tabla Badges, más o menos como sigue:
# ___________________
# id | name    | level       | image
# 1  | creador | inspirado   | creador-inspirado.png
# 2  | creador | blogger     | creador-blogger.png
# 2  | creador | best-seller | creador-bestseller.png
# ___________________
#
#
# 3- La configuración para especificar cuándo aplicar cada badge va en
# app/models/talent_rules.rb, con la siguiente sintaxis:
# 
# grant_on 'users#create', :badge => 'just', :level => 'registered' do
#   # Nothing, or code block which evaluates to true
#   # or with a methods->expected_values hash.
# end
# 
#
# 4- Chequea las condiciones sincronizadamente, o mediante un proceso en
# background, por ejemplo cada 5 minutos (Talent::Rules#check_new_actions).

require 'talent/controller_additions'
require 'talent/rules'

module Talent
  class Engine < Rails::Engine
  end
end