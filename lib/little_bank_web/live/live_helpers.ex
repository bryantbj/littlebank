defmodule LittleBankWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.Component
  import Phoenix.LiveView.Helpers
  import Phoenix.HTML.Form
  import LittleBankWeb.ErrorHelpers
  use Phoenix.HTML

  alias Phoenix.LiveView.JS
  alias LittleBank.{Accounts}

  @doc """
  Returns a socket with `current_user` assigned. Only performs
  lookup if `current_user` isn't already assigned.
  """
  def assign_user(socket = %{assigns: %{current_user: _ }}, _session) do
    socket
  end

  def assign_user(socket, session) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    assign(socket, :current_user, user)
  end

  def format_amount(num) do
    num
    |> Number.Currency.number_to_currency()
  end

  @doc """
  Renders an input field with its label and error messages

  ## Examples
    <.input_field form={f} field={:amount} text={"Amount *"}>
      <%= text_input f, :amount, type: "tel", placeholder: "5.99" %>
    </.input_field>
  """
  def input_field(assigns) do
    assigns = assign_new(assigns, :root_class, fn -> nil end)

    ~H"""
    <div class="form-control" class={@root_class}>
      <%= label @form, @field, class: "label" do %>
        <%= content_tag :span, @text, class: "label-text" %>
      <% end %>
      <%= render_slot(@inner_block) %>
      <%= label @form, @field, class: "label"  do %>
        <%= error_tag @form, @field, class: "label-text-alt text-error" %>
      <% end %>
    </div>
    """
  end

  def input_text_field(assigns) do
    rest =
      assigns
      |> assigns_to_attributes([:form, :field, :text])
      |> Keyword.merge([class: "input input-bordered"])

    assigns = assign(assigns, :rest, rest)

    ~H"""
    <.input_field form={@form} field={@field} text={@text}>
      <%= text_input @form, @field, @rest %>
    </.input_field>
    """
  end


  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.post_index_path(@socket, :index)}>
        <.live_component
          module={LittleBankWeb.PostLive.FormComponent}
          id={@post.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.post_index_path(@socket, :index)}
          post: @post
        />
      </.modal>
  """
  def modal2(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          %>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div class="modal modal-open visible opacity-100">
      <div
        class="modal-box relative border-b-2 border-accent"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: close_btn_classes(),
            phx_click: hide_modal()
          %>
        <% else %>
          <a id="close" href="#" class={close_btn_classes()} phx-click={hide_modal()}>✖</a>
        <% end %>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp close_btn_classes() do
    ~w[
      btn btn-sm btn-circle
      absolute right-2 top-2
    ]
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
