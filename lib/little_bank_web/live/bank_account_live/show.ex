defmodule LittleBankWeb.BankAccountLive.Show do
  use LittleBankWeb, :live_view

  import LittleBankWeb.LiveHelpers
  import LittleBankWeb.BankAccountLive.TransactionComponent, only: [transaction_list_item: 1]

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

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp load_bank_account(current_user) do
    BankAccounts.get_bank_account_for_user!(current_user)
  end

  defp load_transactions(bank_account) do
    BankAccounts.list_last_n_transactions(bank_account, 100)
  end

  defp apply_action(socket, :show, _params) do
    socket
    |> assign(:page_title, "Balance")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transaction")
    |> assign(:transaction, Ecto.build_assoc(socket.assigns.bank_account, :transactions))
  end

end
