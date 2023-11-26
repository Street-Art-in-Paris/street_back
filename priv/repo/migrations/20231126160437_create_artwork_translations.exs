defmodule StreetArt.Repo.Migrations.CreateArtworkTranslations do
  use Ecto.Migration

  def change do
    create table(:artwork_translations, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :artwork_id, references(:artworks, type: :uuid)
      add :locale, :string, size: 10
      add :description, :text
      add :title, :string

      timestamps()
    end
  end
end
