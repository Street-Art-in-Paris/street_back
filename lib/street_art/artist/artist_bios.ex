defmodule StreetArt.ArtistBio.ArtistBios do
  import Ecto.Query, warn: false
  alias StreetArt.ArtistBio
  alias StreetArt.Repo

  def list_artist_bios(params \\ %{}, preload \\ false) do
    params
    |> filter_query()
    |> maybe_preload_artist(preload)
    |> Repo.all()
  end

  def get_artist_bio(id) do
    Repo.get(ArtistBio, id)
  end

  def create_artist_bio(attrs) do
    %ArtistBio{}
    |> ArtistBio.changeset(attrs)
    |> Repo.insert()
  end

  def update_artist_bio(artist_bio, attrs) do
    artist_bio
    |> ArtistBio.changeset(attrs)
    |> Repo.update()
  end

  def delete_artist_bio(artist_bio) do
    Repo.delete(artist_bio)
  end

  defp filter_query(%{artist_id: artist_id, locale: locale}) do
    from ab in ArtistBio, where: ab.artist_id == ^artist_id and ab.locale == ^locale
  end

  defp filter_query(%{locale: locale}) do
    from ab in ArtistBio,
      where: ab.locale == ^locale
  end

  defp filter_query(%{artist_id: artist_id}) do
    from ab in ArtistBio,
      where: ab.artist_id == ^artist_id
  end

  defp filter_query(_) do
    from(ab in ArtistBio, select: ab)
  end

  defp maybe_preload_artist(query, true), do: from(q in query, preload: [:artist])
  defp maybe_preload_artist(query, _), do: query
end
