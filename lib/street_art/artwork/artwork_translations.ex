defmodule StreetArt.ArtworkTranslation.ArtworkTranslations do
  import Ecto.Query, warn: false
  alias StreetArt.ArtworkTranslation
  alias StreetArt.Repo

  def list_artwork_translations(params \\ %{}, preload \\ false) do
    params
    |> filter_query()
    |> maybe_preload_artwork(preload)
    |> Repo.all()
  end

  def get_artwork_translation(id) do
    Repo.get(ArtworkTranslation, id)
  end

  defp filter_query(%{artwork_id: artwork_id, locale: locale}) do
    from at in ArtworkTranslation,
      where: at.artwork_id == ^artwork_id and at.locale == ^locale
  end

  defp filter_query(%{locale: locale}) do
    from at in ArtworkTranslation,
      where: at.locale == ^locale
  end

  defp filter_query(%{artwork_id: artwork_id}) do
    from at in ArtworkTranslation, where: at.artwork_id == ^artwork_id
  end

  defp filter_query(_) do
    from(at in ArtworkTranslation, select: at)
  end

  defp maybe_preload_artwork(query, true), do: from(q in query, preload: [:artwork])
  defp maybe_preload_artwork(query, _), do: query

  def create_artwork_translation(attrs) do
    %ArtworkTranslation{}
    |> ArtworkTranslation.changeset(attrs)
    |> Repo.insert()
  end

  def update_artwork_translation(artwork_translation, attrs \\ %{}) do
    artwork_translation
    |> ArtworkTranslation.changeset(attrs)
    |> Repo.update()
  end

  def delete_artwork_translation(artwork_translation) do
    Repo.delete(artwork_translation)
  end
end
