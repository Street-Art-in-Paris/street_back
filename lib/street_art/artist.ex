defmodule StreetArt.Artist do
  use StreetArt.Schema
  import Ecto.Changeset
  alias StreetArt.ArtistBio
  alias StreetArt.Artwork

  schema "artists" do
    field :avatar, :string
    field :first_name, :string, default: "unknown"
    field :last_name, :string, default: "unknown"
    field :website_url, :string
    has_many :artist_bio, ArtistBio
    has_many :artwork, Artwork
    timestamps()
  end

  @cast_fields [:first_name, :last_name, :website_url, :avatar]
  @update_validation [:first_name, :last_name, :website_url, :avatar]
  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, @cast_fields)
  end

  def update_changeset(artist, attrs) do
    artist
    |> cast(attrs, @cast_fields)
    |> validate_required(@update_validation)
    |> check_updated_changeset()
  end

  defp check_updated_changeset(changeset) do
    if Kernel.map_size(changeset.changes) == 0 do
      changeset
      |> add_error(:base, "At least one field must be updated")
    else
      changeset
    end
  end
end
