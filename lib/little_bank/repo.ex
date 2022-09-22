defmodule LittleBank.Repo do
  use Ecto.Repo,
    otp_app: :little_bank,
    adapter: Ecto.Adapters.Postgres
end
