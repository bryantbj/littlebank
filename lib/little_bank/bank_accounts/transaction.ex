defmodule LittleBank.BankAccounts.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transaction" do
    field :amount, LittleBank.EctoTypes.Money
    field :credit, :boolean, default: false
    field :vendor, :string
    field :note, :string
    field :date, :date
    belongs_to :bank_account, LittleBank.BankAccounts.BankAccount

    timestamps()
  end

  @form_types %{amount: :float, credit: :boolean, vendor: :string, note: :string, date: :date}

  @doc false
  def changeset(transaction, attrs \\ %{}) do
    attrs = Map.merge(%{date: Date.utc_today}, attrs) |> Util.key_to_atom()

    transaction
    |> cast(attrs, [:vendor, :amount, :credit, :note, :date, :bank_account_id])
    |> validate_required([:vendor, :amount, :credit, :date])
    |> validate_number(:amount, greater_than: 0)
  end

  def form_changeset(transaction, attrs \\ %{}) do
    {transaction, @form_types}
    |> Ecto.Changeset.cast(attrs, Map.keys(@form_types))
    |> validate_required(Map.keys(@form_types))
    |> validate_number(:amount, greater_than: 0)
  end

end
