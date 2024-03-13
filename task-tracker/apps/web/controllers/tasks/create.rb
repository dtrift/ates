# frozen_string_literal: true

module Web
  module Controllers
    module Tasks
      class Create
        include Web::Action
        include Import[tasks: 'repositories.task']

        def call(params)
          task = tasks.create(
            title: params[:task][:title],
            description: params[:task][:description],
            public_id: SecureRandom.uuid,
            account_id: current_account.id,
            status: 'opened'
          )

          # ----------------------------- produce event -----------------------
          event = {
            event_name: 'TaskCreated',
            data: {
              public_id: task.public_id,
              title: task.title,
              description: task.description
            }
          }
          WaterDrop::SyncProducer.call(event.to_json, topic: 'billing-created-tasks')
          # --------------------------------------------------------------------

          redirect_to routes.root_path
        end
      end
    end
  end
end
