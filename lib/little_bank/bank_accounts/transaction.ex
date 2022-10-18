defmodule LittleBank.BankAccounts.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
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
    transaction
    |> cast(set_defaults(attrs), [:vendor, :amount, :credit, :note, :date, :bank_account_id])
    |> validate_required([:vendor, :amount, :credit, :date])
    |> validate_number(:amount, greater_than: 0)
  end

  def form_changeset(transaction, attrs \\ %{}) do
    {transaction, @form_types}
    |> Ecto.Changeset.cast(set_defaults(attrs), Map.keys(@form_types))
    |> validate_required(Map.keys(@form_types))
    |> validate_number(:amount, greater_than: 0)
  end

  defp set_defaults(attrs \\ %{}) do
    attrs = %{date: Date.utc_today, credit: false}
    |> Map.merge(attrs)
    |> Util.atomize_map()
  end

end
