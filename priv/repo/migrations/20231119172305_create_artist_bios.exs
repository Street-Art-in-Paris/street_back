defmodule StreetArt.Repo.Migrations.CreateArtistBios do
  use Ecto.Migration

  def change do
    create table(:artist_bios, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :artist_id, references(:artists, type: :uuid)
      add :locale, :string, size: 10
      add :bio_text, :text

      timestamps()
    end
  end
end
