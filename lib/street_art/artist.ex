defmodule StreetArt.Artist do
  use StreetArt.Schema
  import Ecto.Changeset
  alias StreetArt.ArtistBio
  alias StreetArt.Artwork

  schema "artists" do
    field :avatar, :string
    field :first_name, :string
    field :last_name, :string
    field :website_url, :string
    has_many :artist_bio, ArtistBio
    has_many :artwork, Artwork
    timestamps()
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [:first_name, :last_name, :website_url, :avatar])
    |> validate_required([:first_name, :last_name, :website_url, :avatar])
  end
end
