defmodule StreetArt.ArtistBio do
  use StreetArt.Schema
  import Ecto.Changeset
  alias StreetArt.Artist

  schema "artist_bios" do
    field :bio_text, :string
    field :locale, :string
    belongs_to :artist, Artist
    timestamps()
  end

  @doc false
  def changeset(artist_bio, attrs) do
    artist_bio
    |> cast(attrs, [:artist_id, :locale, :bio_text])
    |> validate_required([:artist_id, :locale, :bio_text])
    |> validate_length(:locale, max: 2)
    |> unique_constraint([:artist_id, :locale])
  end
end
