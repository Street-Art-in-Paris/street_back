defmodule StreetArt.Repo.Migrations.CreateArtworks do
  use Ecto.Migration

  def change do
    create table(:artworks, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :artist_id, references(:artists, type: :uuid)
      add :address, :string
      add :city, :string
      add :country, :string
      add :postal_code, :string, size: 10

      timestamps()
    end
  end
end
