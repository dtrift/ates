class BankAccountRepository < Hanami::Repository
  associations do
    belongs_to :account
  end
end
