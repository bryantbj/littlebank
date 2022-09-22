defmodule LittleBankWeb.BankAccountLive.Show do
  use LittleBankWeb, :live_view
  import LittleBankWeb.LiveHelpers, only: [assign_user: 2, format_amount: 1]
  alias LittleBank.{BankAccounts}

  def mount(_params, session, socket) do
    socket = assign_user(socket, session)
    bank_account = load_bank_account(socket.assigns.current_user)
    transactions = load_transactions(bank_account)

    socket =
      socket
      |> assign(:bank_account, bank_account)
      |> assign(:balance_fmt, format_amount(bank_account.balance))
      |> assign(:transactions, transactions)

    {:ok, socket, temporary_assigns: [transactions: []]}
  end

  defp load_bank_account(current_user) do
    BankAccounts.get_bank_account_for_user!(current_user)
  end

  defp load_transactions(bank_account) do
    BankAccounts.get_last_20_transactions(bank_account)
  end
end
