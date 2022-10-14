defmodule LittleBankWeb.BankAccountLive.TransactionComponent do
  use Phoenix.Component
  import LittleBankWeb.LiveHelpers, only: [format_amount: 1]

  def transaction_list_item(assigns) do
    ~H"""
    <article class={article_classes()}>
      <section class="font-mono">
        <%= format_date(@trx.date) %>
      </section>
      <section class="prose order-last row-span-2 md:order-none md:row-span-1 font-light">
        <%= vendor_and_note(@trx) %>
      </section>
      <section class={["font-mono text-right min-w-[16ch] justify-self-end", @trx.credit && "text-accent" || ""]}>
        <%= trx_sign(@trx) %><%= format_amount(@trx.amount) %>
      </section>
    </article>
    """
  end

  defp article_classes() do
    ~w[
      w-full py-3 px-2 grid grid-cols-2 grid-rows-2
      bg-base-300 my-1 rounded-sm

      md:grid-cols-3 md:grid-rows-1

      hover:bg-primary-focus
      hover:text-primary-content
      hover:shadow-sm
      hover:border-l-4 hover:border-l-accent
    ]
  end

  defp trx_sign(trx) do
    trx.credit && "+" || "-"
  end

  defp format_date(date) do
    Calendar.strftime(date, "%m/%d/%Y")
  end

  defp vendor_and_note(trx) do
    [trx.vendor, trx.note]
    |> Enum.filter(& &1)
    |> Enum.join(" / ")
  end
end
