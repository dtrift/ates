# frozen_string_literal: true

module KafkaApp
  module Consumers
    class AccountChanges < Base
      def consume
        params_batch.each do |message|
          puts '-' * 80
          p message
          puts '-' * 80

          case message['event_name']
          when 'AccountCreated'
            # TODO: store accounts in DB
          when 'AccountUpdated'
            account_repo.update_by_public_id(
              message['data']['public_id'],
              full_name: message['data']['full_name'],
              position: message['data']['position']
            )
          when 'AccountDeleted'
            # TODO: remove accounts from DB
          when 'AccountRoleChanged'
            account_repo.update_by_public_id(message['data']['public_id'], role: message['data']['role'])
          else
            # store events in DB
          end
        end
      end

      def account_repo
        Container['repositories.account']
      end
    end
  end
end
