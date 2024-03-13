# frozen_string_literal: true

class TaskRepository < Hanami::Repository
  relations :accounts

  def assigned_for_account(account_id)
    root
      .where(status: 'inprogress', account_id: account_id)
      .map_to(Task).to_a
  end

  def all_for_account(id)
    if accounts.by_pk(id).one&.role == 'admin'
      root.map_to(Task).to_a
    else
      root.where(status: 'inprogress').map_to(Task).to_a
    end
  end

  def assign(task_id, account_id)
    transaction do
      task = update(task_id, account_id: account_id, status: 'inprogress')
      task_status_repo.create(account_id: account_id, task_id: task_id, status: 'inprogress')
      task
    end
  end

  def complete(task_id, account_id)
    transaction do
      task = update(task_id, account_id: account_id, status: 'closed')
      task_status_repo.create(account_id: account_id, task_id: task_id, status: 'closed')
      task
    end
  end

  private

  def task_status_repo
    @task_status_repo ||= TaskStatusRepository.new
  end
end
