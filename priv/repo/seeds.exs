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

build_transactions = fn bank_account_id ->
  range = Date.range(~D[2019-01-01], Date.utc_today())
  timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
  placeholders = %{time: timestamp}
  amounts = Enum.take_every(499..5999, 100)

  Enum.map(1..250, fn _x ->
    %{
      inserted_at: {:placeholder, :time},
      updated_at: {:placeholder, :time},
      bank_account_id: bank_account_id,
      amount: Enum.random(amounts),
      date: Enum.random(range)
    }
    |> Map.merge(
      Enum.random([%{credit: true, vendor: "parents", note: "fun"}, %{credit: false, vendor: "roblox", note: "robux"}, %{credit: false, vendor: "fortnite", note: "vbux"}])
    )
  end)
  |> Enum.sort_by(& &1.date)
end

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
    %{
      bank_account_id: bank_account.id,
      date: ~D[2018-12-25],
      inserted_at: {:placeholder, :time},
      updated_at: {:placeholder, :time},
      credit: true,
      amount: 1_200_000_000,
      vendor: "parents",
      note: "christmas"
    }
    | build_transactions.(bank_account.id)
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
