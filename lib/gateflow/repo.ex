defmodule Gateflow.Repo do
  use Ecto.Repo,
    otp_app: :gateflow,
    adapter: Ecto.Adapters.Postgres
end
