defmodule LittleBank.Repo.Migrations.CreateBankAccounts do
  use Ecto.Migration

  def change do
    create table(:bank_accounts) do
      add :balance, :integer, null: false, default: 0
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:bank_accounts, [:user_id])
  end
end
