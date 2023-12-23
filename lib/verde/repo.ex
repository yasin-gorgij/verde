defmodule Verde.Repo do
  use Ecto.Repo,
    otp_app: :verde,
    adapter: Ecto.Adapters.Postgres
end
