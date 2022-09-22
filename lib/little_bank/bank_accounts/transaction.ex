defmodule LittleBank.BankAccounts.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transaction" do
    field :amount, :integer
    field :credit, :boolean, default: false
    field :vendor, :string
    field :note, :string
    field :date, :date
    belongs_to :bank_account, LittleBank.BankAccounts.BankAccount

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs \\ %{}) do
    attrs = Map.merge(%{date: Date.utc_today}, attrs) |> Util.key_to_atom()

    transaction
    |> cast(attrs, [:vendor, :amount, :credit, :note, :date, :bank_account_id])
    |> validate_required([:vendor, :amount, :credit, :date])
    |> validate_number(:amount, greater_than: 0)
  end

end
