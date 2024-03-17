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
              status: params[:task][:status]
            )

            task_cost = task_costs.create(
              task_public_id: task.public_id,
              value: task_cost_repo.set_cost
            )
  
            # ----------------------------- produce event -----------------------
           task_event = {
              event_name: 'TaskCreated',
              data: {
                public_id: task.public_id,
                title: task.title,
                description: task.description
              }
            }

            task_cost_event ={
              event_name: 'TaskCostIsSet',
              data: {
                task_id: task.id,
                value: task_cost.value
              }
            }
            WaterDrop::SyncProducer.call(task_event.to_json, topic: 'accounting-created-tasks')
            WaterDrop::SyncProducer.call(task_cost_event.to_json, topic: 'accounting-task-cost-is-set')
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

      def task_cost_repo
        Container['repositories.task_cost']
      end
    end
  end
end