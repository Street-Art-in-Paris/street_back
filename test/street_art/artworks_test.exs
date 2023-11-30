defmodule StreetArt.Artwork.ArtworksTest do
  use ExUnit.Case, async: true
  use StreetArt.DataCase

  alias StreetArt.{Factory, Repo, Artwork, Artwork.Artworks}

  describe "create_artwork/1" do
    setup do
      {:ok, artist} = %{} |> Factory.artist() |> Factory.insert()

      {:ok, artist: artist}
    end

    test "with valid attrs should create an artwork", %{artist: artist} do
      attrs = %{
        address: "3 rue du bail",
        city: "Paris",
        country: "FR",
        postal_code: "75013",
        artist_id: artist.id
      }

      {:ok, artwork} = Artworks.create_artwork(attrs)
      assert artwork.id
      assert artwork.address == attrs.address
      assert artwork.city == attrs.city
      assert artwork.country == attrs.country
      assert artwork.postal_code == attrs.postal_code
      assert artwork.artist_id == artist.id
      assert Repo.get(Artwork, artwork.id)
    end

    test "without artist_id should create an artwork and set artist_id to nil" do
      attrs = %{
        address: "3 rue du bail",
        city: "Paris",
        country: "FR",
        postal_code: "75013"
      }

      {:ok, artwork} = Artworks.create_artwork(attrs)
      assert artwork.id
      assert artwork.address == attrs.address
      assert artwork.city == attrs.city
      assert artwork.country == attrs.country
      assert artwork.postal_code == attrs.postal_code
      refute artwork.artist_id
      assert Repo.get(Artwork, artwork.id)
    end

    test "with invalid attrs should return an error" do
      {:error, %Ecto.Changeset{errors: errors}} = Artworks.create_artwork(%{})

      assert errors == [
               address: {"can't be blank", [validation: :required]},
               city: {"can't be blank", [validation: :required]},
               country: {"can't be blank", [validation: :required]},
               postal_code: {"can't be blank", [validation: :required]}
             ]
    end
  end

  describe "update_artwork/2" do
    setup do
      {:ok, artist} = %{} |> Factory.artist() |> Factory.insert()
      {:ok, artwork} = %{artist_id: artist.id} |> Factory.artwork() |> Factory.insert()

      {:ok, artist: artist, artwork: artwork}
    end

    test "with valid attrs should update the artwork", %{artwork: artwork} do
      attrs = %{
        address: "3 rue du bail",
        city: "Paris",
        country: "FR",
        postal_code: "75013"
      }

      {:ok, updated_artwork} = Artworks.update_artwork(artwork, attrs)
      assert updated_artwork.id == artwork.id
      assert updated_artwork.address == attrs.address
      assert updated_artwork.city == attrs.city
      assert updated_artwork.country == attrs.country
      assert updated_artwork.postal_code == attrs.postal_code
    end

    test "should be able to set artist_id to nil", %{artwork: artwork} do
      {:ok, updated_artwork} = Artworks.update_artwork(artwork, %{artist_id: nil})
      assert updated_artwork.id == artwork.id
      refute updated_artwork.artist_id
    end
  end

  describe "list_artworks/0" do
    test "should list all artworks" do
      1..5
      |> Enum.each(fn _ -> {:ok, _} = %{} |> Factory.artwork() |> Factory.insert() end)

      artworks = Artworks.list_artworks()
      assert length(artworks) == 5
    end

    test "with no artwork available should return an empty list" do
      artworks = Artworks.list_artworks()
      assert length(artworks) == 0
    end
  end

  describe "get_artwork/1" do
    setup do
      {:ok, artwork} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork: artwork}
    end

    test "with existing id should return the artwork", %{artwork: artwork} do
      assert Artworks.get_artwork(artwork.id)
    end

    test "with unexistent id should return nil" do
      random_id = Ecto.UUID.generate()
      refute Artworks.get_artwork(random_id)
    end
  end

  describe "delete_artwork/1" do
    setup do
      {:ok, artwork} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork: artwork}
    end

    test "should delete existing artwork", %{artwork: artwork} do
      Artworks.delete_artwork(artwork)
      refute Repo.get(Artwork, artwork.id)
    end
  end
end
