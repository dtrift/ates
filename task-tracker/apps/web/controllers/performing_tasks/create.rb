# frozen_string_literal: true

module Web
  module Controllers
    module PerformingTasks
      class Create
        include Web::Action
        include Import[tasks: 'repositories.task']

        def call(params)
          task = task.assign(params[:task_id].to_i, current_account.id)

          # ----------------------------- produce event -----------------------
          event = {
            event_name: 'TaskAssigned',
            data: {
              public_id: task.public_id,
              status: 'inprogress',
              actor_public_id: current_account.public_id
            }
          }
          
          result = SchemaRegistry.validate_event(
            event,
            'tasks.assigned',
            version: 1
          )

          if result.success?
            WaterDrop::SyncProducer.call(event.to_json, topic: 'task-tracker-inprogress-tasks')
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
