class AuditLogRepository < Hanami::Repository
  associations do
    belongs_to :bank_account
  end
end
