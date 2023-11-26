defmodule StreetArt.Repo.Migrations.CreateItineraryItems do
  use Ecto.Migration

  def change do
    create table(:itinerary_items, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :itinerary_id, references(:itineraries, type: :uuid)
      add :artwork_id, references(:artworks, type: :uuid)
      add :artist_id, references(:artists, type: :uuid)
      add :latitude, :float
      add :longitude, :float

      timestamps()
    end
  end
end
