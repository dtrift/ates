Hanami::Model.migration do
  change do
    create_table :task_costs do
      primary_key :id

      foreign_key :task_id, :tasks, on_delete: :cascade

      column :task_public_id, String, null: false
      column :value, Float, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
