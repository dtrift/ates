Hanami::Model.migration do
  change do
    create_table :audit_logs do
      primary_key :id

      foreign_key :bank_account_id, :bank_accounts, on_delete: :cascade

      column :result, :jsonb, default: '{}'

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
