defmodule LittleBank.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :vendor, :string, null: false
      add :amount, :integer, null: false
      add :credit, :boolean, default: false, null: false
      add :note, :string
      add :date, :date, null: false
      add :bank_account_id, references(:bank_accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:bank_account_id])
  end
end
