defmodule Elmix.Repo do
  use Ecto.Repo,
    otp_app: :elmix,
    adapter: Ecto.Adapters.Postgres
end
