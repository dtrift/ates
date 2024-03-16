# frozen_string_literal: true

class Task < Hanami::Entity
  def completed?
    status == 'closed'
  end
end
