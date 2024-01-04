defmodule StreetArt.Itinerary do
  use StreetArt.Schema
  import Ecto.Changeset
  alias StreetArt.User
  alias StreetArt.ItineraryItem

  @primary_key {:id, Ecto.UUID, autogenerate: false}
  @foreign_key_type Ecto.UUID
  schema "itineraries" do
    field :description, :string
    field :title, :string

    belongs_to :user, User
    has_many :itinerary_item, ItineraryItem
    timestamps()
  end

  @doc false
  def changeset(itinerary, attrs) do
    itinerary
    |> cast(attrs, [:user_id, :title, :description])
    |> validate_required([:user_id, :title, :description])
  end
end
