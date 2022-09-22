defmodule Play do
  alias LittleBank.{
    Accounts,
    Accounts.User,
    BankAccounts,
    BankAccounts.BankAccount,
    Repo
  }

  import Ecto.Query
  import Ecto.Changeset

  def play do
    attrs = %{
      "name" => "BJ",
      "email" => "bryantb76@gmail.com",
      "password" => "dis a bad password",
      "password_confirmation" => "dis a bad password"
    }

    Accounts.register_user(attrs)
  end
end
