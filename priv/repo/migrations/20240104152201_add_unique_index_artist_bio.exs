defmodule StreetArt.Repo.Migrations.AddUniqueIndexArtistBio do
  use Ecto.Migration

  def change do
    create unique_index(:artist_bios, [:artist_id, :locale])
  end
end
