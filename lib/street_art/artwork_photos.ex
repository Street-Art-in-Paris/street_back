defmodule StreetArt.ArtworkPhoto.ArtworkPhotos do
  import Ecto.Query, warn: false
  alias StreetArt.ArtworkPhoto
  alias StreetArt.Repo

  def create_artwork_photo(attrs \\ %{}) do
    %ArtworkPhoto{}
    |> ArtworkPhoto.changeset(attrs)
    |> Repo.insert()
  end

  def update_artwork_photo(artwork_photo, attrs \\ %{}) do
    artwork_photo
    |> ArtworkPhoto.changeset(attrs)
    |> Repo.update()
  end

  def list_artwork_photos(artwork_id \\ nil, preload \\ false) do
    artwork_id
    |> filter_query
    |> maybe_preload_artwork(preload)
    |> Repo.all()
  end

  def get_artwork_photo(id) do
    Repo.get(ArtworkPhoto, id)
  end

  def delete_artwork_photo(artwork_photo) do
    Repo.delete(artwork_photo)
  end

  defp maybe_preload_artwork(query, true), do: from(q in query, preload: [:artwork])
  defp maybe_preload_artwork(query, _), do: query

  defp filter_query(nil) do
    from(ap in ArtworkPhoto, select: ap)
  end

  defp filter_query(artwork_id) do
    from ap in ArtworkPhoto, where: ap.artwork_id == ^artwork_id, select: ap
  end
end
