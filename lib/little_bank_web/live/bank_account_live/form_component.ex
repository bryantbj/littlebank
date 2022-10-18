defmodule LittleBankWeb.BankAccountLive.FormComponent do
  use LittleBankWeb, :live_component

  alias LittleBank.{BankAccounts}

  @impl true
  def update(%{transaction: transaction, bank_account: _bank_account} = assigns, socket) do
    changeset = transaction
    |> BankAccounts.change_transaction()

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
    types = %{amount: :float, vendor: :string, note: :string, date: :date, credit: :boolean, bank_account_id: :integer}

    trx_params = {%{}, types}
    |> Ecto.Changeset.cast(trx_params, Map.keys(types))
    |> Map.get(:changes)
    |> Map.update!(:amount, & trunc(&1 * 100))

    save_transaction(socket, socket.assigns.action, trx_params)
  end

  defp save_transaction(socket, :new, trx_params) do
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
