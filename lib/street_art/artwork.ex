defmodule StreetArt.Artwork do
  use StreetArt.Schema
  import Ecto.Changeset
  alias StreetArt.ArtworkPhoto
  alias StreetArt.Artist
  alias StreetArt.ArtworkTranslation

  schema "artworks" do
    field :address, :string
    field :city, :string
    field :country, :string
    field :postal_code, :string

    belongs_to :artist, Artist
    has_many :artwork_photo, ArtworkPhoto
    has_many :artwork_translation, ArtworkTranslation

    timestamps()
  end

  @doc false
  def changeset(artwwork, attrs) do
    artwwork
    |> cast(attrs, [:address, :city, :country, :postal_code])
    |> validate_required([:address, :city, :country, :postal_code])
    |> cast_artist(attrs)
  end

  defp cast_artist(changeset, attrs) do
    if Map.has_key?(attrs, :artist_id) do
      put_change(changeset, :artist_id, Map.get(attrs, :artist_id))
    else
      put_change(changeset, :artist_id, nil)
    end
  end
end
