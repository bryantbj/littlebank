defmodule LittleBank.BankAccountsTest do
  use LittleBank.DataCase

  alias LittleBank.BankAccounts

  describe "bank_accounts" do
    alias LittleBank.BankAccounts.BankAccount

    import LittleBank.{BankAccountsFixtures, AccountsFixtures}

    @invalid_attrs %{balance: nil}

    test "list_bank_accounts/0 returns all bank_accounts" do
      %{bank_account: bank_account} = user_fixture() |> Repo.preload(:bank_account)

      assert BankAccounts.list_bank_accounts() == [bank_account]
    end

    test "get_bank_account!/1 returns the bank_account with given id" do
      bank_account = bank_account_fixture()
      assert BankAccounts.get_bank_account!(bank_account.id) == bank_account
    end

    test "get_bank_account_for_user!/1 returns the bank_account for the given user" do
      user = user_fixture() |> Repo.preload(:bank_account)

      assert BankAccounts.get_bank_account_for_user!(user) == user.bank_account
    end

    # test "create_bank_account/1 with valid data creates a bank_account" do
    #   %{id: id} = user_fixture()
    #   valid_attrs = %{balance: 42, user: %{id: id}}

    #   assert {:ok, %BankAccount{} = bank_account} = BankAccounts.create_bank_account(valid_attrs)
    #   assert bank_account.balance == 42
    # end

    # test "create_bank_account/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = BankAccounts.create_bank_account(@invalid_attrs)
    # end

    test "update_bank_account/2 with valid data updates the bank_account" do
      bank_account = bank_account_fixture()
      update_attrs = %{balance: 43}

      assert {:ok, %BankAccount{} = bank_account} =
               BankAccounts.update_bank_account(bank_account, update_attrs)

      assert bank_account.balance == 43
    end

    test "update_bank_account/2 with invalid data returns error changeset" do
      bank_account = bank_account_fixture()

      assert {:error, %Ecto.Changeset{}} =
               BankAccounts.update_bank_account(bank_account, @invalid_attrs)

      assert bank_account == BankAccounts.get_bank_account!(bank_account.id)
    end

    test "delete_bank_account/1 deletes the bank_account" do
      bank_account = bank_account_fixture()
      assert {:ok, %BankAccount{}} = BankAccounts.delete_bank_account(bank_account)
      assert_raise Ecto.NoResultsError, fn -> BankAccounts.get_bank_account!(bank_account.id) end
    end

    test "change_bank_account/1 returns a bank_account changeset" do
      bank_account = bank_account_fixture()
      assert %Ecto.Changeset{} = BankAccounts.change_bank_account(bank_account)
    end

    test "bank_account_transaction/2 with valid params returns a transaction" do
      %{id: id} = bank_account = bank_account_fixture()

      attrs = %{
        amount: 10_000,
        vendor: "parents",
        credit: true,
        note: "bday",
        date: ~D[2022-05-08]
      }

      {:ok, %{transaction: transaction}} = BankAccounts.bank_account_transaction(bank_account, attrs)
      assert %BankAccounts.Transaction{} = transaction
      assert transaction.amount == attrs.amount
      assert transaction.vendor == attrs.vendor
      assert transaction.bank_account_id == id
      assert transaction.credit == attrs.credit
      assert transaction.note == attrs.note
      assert transaction.date == attrs.date
    end

    test "bank_account_transaction/2 updates bank account balance" do
      bank_account = bank_account_fixture()
      balance_pre = bank_account.balance
      attrs = transaction_attrs(%{credit: true})

      {:ok, %{bank_account: bank_account, transaction: transaction}} =
        BankAccounts.bank_account_transaction(bank_account, attrs)

        assert bank_account.balance == balance_pre + attrs.amount
    end

    test "bank_account_transaction/2 with invalid params returns an error" do
      bank_account = bank_account_fixture()
      attrs = %{amount: -1, credit: false, vendor: ""}

      {:error, :transaction, %{errors: errors}, _changes} = BankAccounts.bank_account_transaction(bank_account, attrs)
      assert Keyword.has_key?(errors, :amount)
      assert Keyword.has_key?(errors, :vendor)
    end
  end

  describe "transaction" do
    alias LittleBank.BankAccounts.Transaction

    import LittleBank.BankAccountsFixtures

    @invalid_attrs %{amount: nil, credit: nil, vendor: nil}

    test "list_transaction/0 returns all transaction" do
      transaction = transaction_fixture()
      assert BankAccounts.list_transaction() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert BankAccounts.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{amount: 42, credit: true, vendor: "some vendor"}

      assert {:ok, %Transaction{} = transaction} = BankAccounts.create_transaction(valid_attrs)
      assert transaction.amount == 42
      assert transaction.credit == true
      assert transaction.vendor == "some vendor"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BankAccounts.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{amount: 43, credit: false, vendor: "some updated vendor"}

      assert {:ok, %Transaction{} = transaction} =
               BankAccounts.update_transaction(transaction, update_attrs)

      assert transaction.amount == 43
      assert transaction.credit == false
      assert transaction.vendor == "some updated vendor"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()

      assert {:error, %Ecto.Changeset{}} =
               BankAccounts.update_transaction(transaction, @invalid_attrs)

      assert transaction == BankAccounts.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = BankAccounts.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> BankAccounts.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = BankAccounts.change_transaction(transaction)
    end
  end
end
