defmodule LittleBank.BankAccountsFixtures do
  import LittleBank.AccountsFixtures
  alias LittleBank.{BankAccounts.BankAccount, Repo}

  @moduledoc """
  This module defines test helpers for creating
  entities via the `LittleBank.BankAccounts` context.
  """

  @doc """
  Generate a bank_account.
  """
  def bank_account_fixture(attrs \\ %{}) do
    %{id: id} = user_fixture()
    attrs = Enum.into(attrs, %{balance: 42, user_id: id})

    {:ok, bank_account} = %BankAccount{} |> BankAccount.changeset(attrs) |> Repo.insert()

    bank_account
  end

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: 42,
        credit: true,
        vendor: "some vendor"
      })
      |> LittleBank.BankAccounts.create_transaction()

    transaction
  end

  def transaction_attrs(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      amount: 12000,
      credit: true,
      vendor: "parents",
      note: "bday",
      date: ~D[2022-05-08]
    })
  end
end
