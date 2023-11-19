defmodule StreetArt.Repo do
  use Ecto.Repo,
    otp_app: :street_art,
    adapter: Ecto.Adapters.Postgres
end
