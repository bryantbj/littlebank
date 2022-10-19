defmodule LittleBank.BankAccounts.BankAccount do
  use Ecto.Schema
  import Ecto.Changeset
  alias LittleBank.{Accounts.User, BankAccounts.Transaction}

  schema "bank_accounts" do
    field :balance, LittleBank.EctoTypes.Money, default: 0
    belongs_to :user, User
    has_many :transactions, Transaction

    timestamps()
  end

  @doc false
  def changeset(bank_account, attrs) do
    bank_account
    |> cast(attrs, [:balance, :user_id])
    |> cast_assoc(:user)
    |> validate_required([:balance])
  end


  def balance_changeset(bank_account, %{amount: amount} = attrs) do
    credit = Map.get(attrs, :credit, false)
    attrs = %{balance: credit && bank_account.balance + amount || bank_account.balance - amount}

    bank_account
    |> changeset(attrs)
  end
end
