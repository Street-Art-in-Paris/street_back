defmodule StreetArt.Artist.Artists do
  import Ecto.Query, warn: false
  alias StreetArt.Artist
  alias StreetArt.Repo

  def create_artist(attrs \\ %{}) do
    %Artist{}
    |> Artist.changeset(attrs)
    |> Repo.insert()
  end

  def update_artist(artist, attrs \\ %{}) do
    artist
    |> Artist.update_changeset(attrs)
    |> Repo.update()
  end

  def get_artist(id) do
    Repo.get(Artist, id)
  end

  def list_artists do
    Repo.all(Artist)
  end

  def delete_artist(artist) do
    Repo.delete(artist)
  end
end
