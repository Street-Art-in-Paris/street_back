defmodule StreetArt.Repo.Migrations.CreateArtworkPhotos do
  use Ecto.Migration

  def change do
    create table(:artwork_photos, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :artwork_id, references(:artworks, type: :uuid)
      add :photo_url, :string
      add :is_main, :boolean, default: false, null: false

      timestamps()
    end
  end
end
