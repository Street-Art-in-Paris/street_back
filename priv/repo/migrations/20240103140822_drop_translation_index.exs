defmodule StreetArt.Repo.Migrations.DropTranslationIndex do
  use Ecto.Migration

  def change do
    drop index(:artwork_translations, [:locale])
  end
end
