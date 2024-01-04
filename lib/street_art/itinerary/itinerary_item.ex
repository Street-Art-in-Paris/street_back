defmodule StreetArt.ItineraryItem do
  use StreetArt.Schema
  import Ecto.Changeset
  alias StreetArt.Itinerary
  alias StreetArt.Artwork
  alias StreetArt.Artist

  @primary_key {:id, Ecto.UUID, autogenerate: false}
  @foreign_key_type Ecto.UUID
  schema "itinerary_items" do
    field :latitude, :float
    field :longitude, :float

    belongs_to :itinerary, Itinerary
    belongs_to :artwork, Artwork
    belongs_to :artist, Artist

    timestamps()
  end

  @doc false
  def changeset(itinerary_item, attrs) do
    itinerary_item
    |> cast(attrs, [:itinerary_id, :artwork_id, :artist_id, :latitude, :longitude])
    |> validate_required([:itinerary_id, :artwork_id, :artist_id, :latitude, :longitude])
  end
end
