# frozen_string_literal: true

module KafkaApp
  module Consumers
    class TaskChanges < Base
      def consume
        params_batch.each do |message|
          puts '-' * 80
          p message
          puts '-' * 80

          case message['event_name']
          when 'TaskCreated'
            task = tasks.create(
              title: params[:task][:title],
              description: params[:task][:description],
              public_id: SecureRandom.uuid,
              account_id: current_account.id,
              status: params[:task][:status],
              cost: tasks.set_cost_by_status(params[:task][:status])
            )
  
            # ----------------------------- produce event -----------------------
            event = {
              event_name: 'TaskCreated',
              data: {
                public_id: task.public_id,
                title: task.title,
                description: task.description,
                cost: task.cost
              }
            }
            WaterDrop::SyncProducer.call(event.to_json, topic: 'accounting-created-tasks')
            # --------------------------------------------------------------------
          when 'TaskUpdated'
            task_repo.update_by_public_id(
              message['data']['public_id'],
              status: message['data']['status']
            )
          else
            # store events in DB
          end
        end
      end

      def task_repo
        Container['repositories.task']
      end
    end
  end
end