defmodule StreetArt.ArtworkPhoto do
  use StreetArt.Schema
  import Ecto.Changeset
  alias StreetArt.Artwork

  schema "artwork_photos" do
    field :is_main, :boolean, default: false
    field :photo_url, :string

    belongs_to :artwork, Artwork
    timestamps()
  end

  @doc false
  def changeset(artwork_photo, attrs) do
    artwork_photo
    |> cast(attrs, [:artwork_id, :photo_url, :is_main])
    |> validate_required([:artwork_id, :photo_url, :is_main])
  end
end
