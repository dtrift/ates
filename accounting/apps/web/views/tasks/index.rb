# frozen_string_literal: true

module Web
  module Views
    module Tasks
      class Index
        include Web::View

        def current_account_admin?
          AccountRepository.new.find(current_account.id).role == 'admin'
        end

      end
    end
  end
end
