defmodule StreetArt.Artwork.Artworks do
  import Ecto.Query, warn: false
  alias StreetArt.Artwork
  alias StreetArt.Repo

  def create_artwork(attrs \\ %{}) do
    %Artwork{}
    |> Artwork.changeset(attrs)
    |> Repo.insert()
  end

  def update_artwork(artwork, attrs \\ %{}) do
    artwork
    |> Artwork.changeset(attrs)
    |> Repo.update()
  end

  def get_artwork(id) do
    Repo.get(Artwork, id)
  end

  def list_artworks do
    Repo.all(Artwork)
  end

  def delete_artwork(artwork) do
    Repo.delete(artwork)
  end
end
