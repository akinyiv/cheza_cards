defmodule ChezaCards.Repo do
  use Ecto.Repo,
    otp_app: :cheza_cards,
    adapter: Ecto.Adapters.Postgres
end
