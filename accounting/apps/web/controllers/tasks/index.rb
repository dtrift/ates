# frozen_string_literal: true

module Web
  module Controllers
    module Tasks
      class Index
        include Web::Action
        include Import[tasks: 'repositories.task']

        expose :tasks, :my_tasks

        def call(_params)
          @my_tasks = tasks.assigned_for_account(current_account.id)
          @tasks = tasks.all_for_account(current_account.id)
        end
      end
    end
  end
end
