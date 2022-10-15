defmodule LittleBankWeb.BankAccountLive.FormComponent do
  use LittleBankWeb, :live_component

  alias LittleBank.{BankAccounts}

  @impl true
  def update(%{transaction: transaction, bank_account: bank_account} = assigns, socket) do
    IO.inspect(assigns, label: "assigns")
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
      |> BankAccounts.change_transaction(trx_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"transaction" => trx_params}, socket) do
    save_transaction(socket, socket.assigns.action, trx_params)
  end

  # defp save_transaction(socket, :edit, post_params) do
  #   case Examples.update_post(socket.assigns.post, post_params) do
  #     {:ok, _post} ->
  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Post updated successfully")
  #        |> push_redirect(to: socket.assigns.return_to)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign(socket, :changeset, changeset)}
  #   end
  # end

  defp save_transaction(socket, :new, trx_params) do
    case BankAccounts.bank_account_transaction(socket.assigns.bank_account, trx_params) do
      {:ok, _trx} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
