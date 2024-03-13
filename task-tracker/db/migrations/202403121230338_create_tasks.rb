# frozen_string_literal: true

Hanami::Model.migration do
  change do
    create_enum(:task_statuses_list, %w[opened inprogress closed])

    create_table :tasks do
      primary_key :id

      foreign_key :account_id, :accounts, on_delete: :cascade, null: true

      column :public_id,   String, null: false
      column :title,       String, null: false
      column :description, String

      column :status, 'task_statuses_list', null: false

      column :meta, :jsonb, default: '{}'

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
