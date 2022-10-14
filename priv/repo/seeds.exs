# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LittleBank.Repo.insert!(%LittleBank.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias LittleBank.{Accounts, BankAccounts, BankAccounts.Transaction, Repo}

if Mix.env() == :dev do
  {:ok, user} =
    Accounts.register_user(%{
      name: "BJ",
      email: "bryantb76@gmail.com",
      password: "dis a bad password",
      password_confirmation: "dis a bad password"
    })

    bank_account = BankAccounts.get_bank_account_for_user!(user)

    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    placeholders = %{time: timestamp}

  entries = [
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: true, amount: 1_200_000_00, vendor: "parents", note: "bday", date: ~D[2022-05-08]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 899, vendor: "roblox", note: "robux", date: ~D[2022-05-10]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 499, vendor: "roblox", note: "robux", date: ~D[2022-05-22]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 1999, vendor: "fortnite", note: "vbux", date: ~D[2022-05-24]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 899, vendor: "roblox", note: "robux", date: ~D[2022-05-26]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 899, vendor: "roblox", note: "robux", date: ~D[2022-06-02]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 899, vendor: "roblox", note: "robux", date: ~D[2022-06-08]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 899, vendor: "roblox", note: "robux", date: ~D[2022-06-14]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 899, vendor: "roblox", note: "robux", date: ~D[2022-06-20]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 899, vendor: "roblox", note: "robux", date: ~D[2022-06-30]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 499, vendor: "roblox", note: "robux", date: ~D[2022-07-01]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 1999, vendor: "fortnite", note: "vbux", date: ~D[2022-07-08]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 499, vendor: "roblox", note: "robux", date: ~D[2022-07-11]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 1999, vendor: "fortnite", note: "vbux", date: ~D[2022-07-19]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 499, vendor: "roblox", note: "robux", date: ~D[2022-07-28]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 1999, vendor: "fortnite", note: "vbux", date: ~D[2022-07-31]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 499, vendor: "roblox", note: "robux", date: ~D[2022-08-02]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 1999, vendor: "fortnite", note: "vbux", date: ~D[2022-08-10]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 499, vendor: "roblox", note: "robux", date: ~D[2022-08-12]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 1999, vendor: "fortnite", note: "vbux", date: ~D[2022-08-13]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 499, vendor: "roblox", note: "robux", date: ~D[2022-08-19]},
    %{inserted_at: {:placeholder, :time}, updated_at: {:placeholder, :time}, bank_account_id: bank_account.id, credit: false, amount: 1999, vendor: "fortnite", note: "vbux", date: ~D[2022-08-27]}
  ]

  balance =
    entries
    |> Enum.map(& &1.amount)
    |> Enum.sum()

  Repo.insert_all(Transaction, entries, placeholders: placeholders)

  bank_account
  |> BankAccounts.change_bank_account(%{balance: balance})
  |> Repo.update()
end
