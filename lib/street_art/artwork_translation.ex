defmodule StreetArt.ArtworkTranslation do
  use StreetArt.Schema
  import Ecto.Changeset
  alias StreetArt.Artwork

  schema "artwork_translations" do
    field :description, :string
    field :locale, :string
    field :title, :string

    belongs_to :artwork, Artwork
    timestamps()
  end

  @doc false
  def changeset(artwork_translation, attrs) do
    artwork_translation
    |> cast(attrs, [:artwork_id, :locale, :description, :title])
    |> validate_required([:artwork_id, :locale, :description, :title])
    |> validate_length(:locale, max: 2)
    |> unique_constraint([:artwork_id, :locale])
  end
end
