# frozen_string_literal: true

module Web
  module Controllers
    module PerformingTasks
      class Destroy
        include Web::Action
        include Import[tasks: 'repositories.task']

        def call(params)
          task = tasks.complete(params[:task_id].to_i, current_account.id)

          # ----------------------------- produce event -----------------------
          event = {
            event_name: 'TasksCompleted',
            data: {
              public_id: task.public_id,
              status: 'closed',
              actor_public_id: current_account.public_id
            }
          }
          WaterDrop::SyncProducer.call(event.to_json, topic: 'billing-closed-tasks')
          # --------------------------------------------------------------------

          redirect_to routes.root_path
        end

        private

        def verify_csrf_token?
          false
        end
      end
    end
  end
end
