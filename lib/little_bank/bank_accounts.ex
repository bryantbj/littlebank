defmodule LittleBank.BankAccounts do
  @moduledoc """
  The BankAccounts context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias LittleBank.Repo

  alias LittleBank.{Accounts.User, BankAccounts.BankAccount, BankAccounts.Transaction}

  @doc """
  Returns the list of bank_accounts.

  ## Examples

      iex> list_bank_accounts()
      [%BankAccount{}, ...]

  """
  def list_bank_accounts do
    Repo.all(BankAccount)
  end

  @doc """
  Gets a single bank_account.

  Raises `Ecto.NoResultsError` if the Bank account does not exist.

  ## Examples

      iex> get_bank_account!(123)
      %BankAccount{}

      iex> get_bank_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bank_account!(id), do: Repo.get!(BankAccount, id)

  def get_bank_account_for_user!(user_id) when is_integer(user_id), do: Repo.get_by!(BankAccount, [user_id: user_id])
  def get_bank_account_for_user!(%User{id: id}), do: get_bank_account_for_user!(id)

  @doc """
  Creates a bank_account.

  ## Examples

      iex> create_bank_account(%{field: value})
      {:ok, %BankAccount{}}

      iex> create_bank_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bank_account(_attrs \\ %{}) do
    raise("not implemented")

    # %BankAccount{}
    # |> BankAccount.changeset(attrs)
    # |> Repo.insert()
  end

  @doc """
  Updates a bank_account.

  ## Examples

      iex> update_bank_account(bank_account, %{field: new_value})
      {:ok, %BankAccount{}}

      iex> update_bank_account(bank_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bank_account(%BankAccount{} = bank_account, attrs) do
    bank_account
    |> BankAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bank_account.

  ## Examples

      iex> delete_bank_account(bank_account)
      {:ok, %BankAccount{}}

      iex> delete_bank_account(bank_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bank_account(%BankAccount{} = bank_account) do
    Repo.delete(bank_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bank_account changes.

  ## Examples

      iex> change_bank_account(bank_account)
      %Ecto.Changeset{data: %BankAccount{}}

  """
  def change_bank_account(%BankAccount{} = bank_account, attrs \\ %{}) do
    BankAccount.changeset(bank_account, attrs)
  end

  alias LittleBank.BankAccounts.Transaction

  def bank_account_transaction(%BankAccount{} = bank_account, attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:transaction, Ecto.build_assoc(bank_account, :transactions)
    |> Transaction.changeset(attrs))
    |> Multi.update(:bank_account, BankAccount.balance_changeset(bank_account, attrs))
    |> Repo.transaction()
  end

  @doc """
  Returns the list of transaction.

  ## Examples

      iex> list_transaction()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  def list_transactions_query(%BankAccount{id: id}) do
      from t in Transaction,
      where: t.bank_account_id == ^id,
      order_by: [desc: :date, desc: :inserted_at]
  end

  def list_transactions(%BankAccount{id: _id} = bank_account) do
    list_transactions_query(bank_account)
    |> Repo.all()
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  def list_last_20_transactions(%BankAccount{id: _id} = bank_account) do
    from(q in list_transactions_query(bank_account), limit: 20)
    |> Repo.all()

    # q =
    #   from t in Transaction,
    #   where: t.bank_account_id == ^id,
    #   order_by: [desc: :date, desc: :inserted_at],
    #   limit: 20
    # Repo.all(q)
  end

  def list_last_n_transactions(%BankAccount{id: _id} = bank_account, num) do
    from(q in list_transactions_query(bank_account), limit: ^num)
    |> Repo.all()
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
