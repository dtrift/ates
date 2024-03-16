# frozen_string_literal: true

get '/login', to: 'signin#index', as: 'login'
get '/logout', to: 'oauth_session#destroy'
get '/auth/:provider/callback', to: 'oauth_session#create'
