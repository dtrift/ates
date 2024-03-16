# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_table :task_statuses do
      primary_key :id

      foreign_key :account_id, :accounts, on_delete: :cascade
      foreign_key :task_id, :tasks, on_delete: :cascade

      column :status, String, null: false
      column :comment, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
