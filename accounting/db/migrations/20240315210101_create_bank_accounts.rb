Hanami::Model.migration do
  change do
    create_table :bank_accounts do
      primary_key :id

      foreign_key :account_id, :accounts, on_delete: :cascade

      column :number, Integer, null: false
      column :balance, Float, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
