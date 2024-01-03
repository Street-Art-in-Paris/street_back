defmodule StreetArt.Repo.Migrations.AddUniqueIndexTranslations do
  use Ecto.Migration

  def change do
    create unique_index(:artwork_translations, [:artwork_id, :locale])
  end
end
