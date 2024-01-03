defmodule StreetArt.Repo.Migrations.AddTranslationUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:artwork_translations, [:locale])
  end
end
