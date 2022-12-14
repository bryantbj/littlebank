defmodule LittleBankWeb.BankAccountLive.FormComponent do
  use LittleBankWeb, :live_component

  alias LittleBank.{BankAccounts}

  @impl true
  def update(%{transaction: transaction, bank_account: _bank_account} = assigns, socket) do
    changeset = transaction
    |> BankAccounts.transaction_form_changeset()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"transaction" => trx_params}, socket) do
    changeset =
      socket.assigns.transaction
      |> BankAccounts.transaction_form_changeset(trx_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"transaction" => trx_params}, socket) do
    %{changes: attrs} = socket.assigns.transaction |> BankAccounts.transaction_form_changeset(trx_params)

    save_transaction(socket, socket.assigns.action, attrs)
  end

  defp save_transaction(socket, :new, trx_params) do
    # case BankAccounts.bank_account_transaction(socket.assigns.bank_account, socket.assigns.changeset.changes) do
    case BankAccounts.bank_account_transaction(socket.assigns.bank_account, trx_params) do
      {:ok, _trx} ->
        {:noreply,
         socket
         |> put_flash(:info, "Transaction added successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
