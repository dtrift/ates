# frozen_string_literal: true

# Configure your routes here
# See: http://hanamirb.org/guides/routing/overview/
#
# Example:
# get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
root to: 'tasks#index'

resource :tasks, only: %i[index new create]
resource :performing_tasks, only: %i[create destroy]
