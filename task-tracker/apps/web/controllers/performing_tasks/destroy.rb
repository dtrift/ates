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

          result = SchemaRegistry.validate_event(
            event,
            'tasks.completed',
            version: 1
          )

          if result.success?
            WaterDrop::SyncProducer.call(event.to_json, topic: 'task-tracker-closed-tasks')
          end
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
