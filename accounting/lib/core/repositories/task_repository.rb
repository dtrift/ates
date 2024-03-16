# frozen_string_literal: true

class TaskRepository < Hanami::Repository
  relations :accounts

  def set_cost_by_status(status)
    case status
    when 'assigned'
      rand(10..20)
    when 'closed'
      rand(20..40)
    else
      # invalid status
    end
  end

  private

  def task_status_repo
    @task_status_repo ||= TaskStatusRepository.new
  end
end
