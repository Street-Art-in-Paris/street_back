defmodule StreetArt.Repo.Migrations.CreateArtists do
  use Ecto.Migration

  def change do
    create table(:artists, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :first_name, :string
      add :last_name, :string
      add :website_url, :string
      add :avatar, :string

      timestamps()
    end
  end
end
