defmodule StreetArt.ArtworkPhoto.ArtworkPhotosTest do
  use ExUnit.Case, async: true
  use StreetArt.DataCase

  alias StreetArt.{Factory, Repo, ArtworkPhoto, ArtworkPhoto.ArtworkPhotos}

  describe "create_artwork_photo/1" do
    setup do
      {:ok, artwork} = %{} |> Factory.artwork() |> Factory.insert()
      {:ok, artwork: artwork}
    end

    test "with valid attrs should create an artwork photo", %{artwork: artwork} do
      attrs = %{
        photo_url: "foo/bar.jpg",
        is_main: true,
        artwork_id: artwork.id
      }

      {:ok, artwork_photo} = ArtworkPhotos.create_artwork_photo(attrs)
      assert artwork_photo.id
      assert artwork_photo.photo_url == attrs.photo_url
      assert artwork_photo.is_main
      assert artwork_photo.artwork_id == artwork.id
    end

    test "without artwork_id should not create the photo and return an error" do
      attrs = %{
        photo_url: "foo/bar.jpg",
        is_main: true
      }

      {:error, %Ecto.Changeset{errors: errors}} = ArtworkPhotos.create_artwork_photo(attrs)
      assert errors == [artwork_id: {"can't be blank", [validation: :required]}]
    end

    test "with valid attrs and without is_main info should create a photo and set the value to false ",
         %{artwork: artwork} do
      attrs = %{
        photo_url: "foo/bar.jpg",
        artwork_id: artwork.id
      }

      {:ok, artwork_photo} = ArtworkPhotos.create_artwork_photo(attrs)
      assert artwork_photo.id
      assert artwork_photo.photo_url == attrs.photo_url
      assert artwork_photo.is_main == false
      assert artwork_photo.artwork_id == artwork.id
    end
  end

  describe "update_artwork_photo/2" do
    setup do
      {:ok, artwork} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork_photo} =
        %{arwork_id: artwork.id} |> Factory.artwork_photo() |> Factory.insert()

      {:ok, artwork: artwork, artwork_photo: artwork_photo}
    end

    test "with valid attrs should update the given photo", %{
      artwork_photo: artwork_photo,
      artwork: artwork
    } do
      attrs = %{
        photo_url: "new/url.jpg",
        artwork_id: artwork.id
      }

      {:ok, updated_photo} = ArtworkPhotos.update_artwork_photo(artwork_photo, attrs)
      assert updated_photo.id == artwork_photo.id
      assert updated_photo.photo_url == attrs.photo_url
      refute updated_photo.photo_url == artwork_photo.photo_url
    end

    test "with is_main = true should set the value to true", %{
      artwork_photo: artwork_photo,
      artwork: artwork
    } do
      attrs = %{
        artwork_id: artwork.id,
        is_main: true
      }

      {:ok, updated_photo} = ArtworkPhotos.update_artwork_photo(artwork_photo, attrs)
      assert updated_photo.id == artwork_photo.id
      assert updated_photo.is_main
      refute artwork_photo.is_main
    end

    test "without artwork_id should not update and return an error", %{
      artwork_photo: artwork_photo
    } do
      attrs = %{
        is_main: true
      }

      {:error, %Ecto.Changeset{errors: errors}} =
        ArtworkPhotos.update_artwork_photo(artwork_photo, attrs)

      assert errors == [artwork_id: {"can't be blank", [validation: :required]}]
      refute artwork_photo.is_main
    end
  end

  describe "list_artwork_photos/2" do
    setup do
      {:ok, artwork_1} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork_photo_1} =
        %{artwork_id: artwork_1.id} |> Factory.artwork_photo() |> Factory.insert()

      {:ok, artwork_photo_2} =
        %{artwork_id: artwork_1.id} |> Factory.artwork_photo() |> Factory.insert()

      {:ok,
       artwork_1: artwork_1, artwork_photo_1: artwork_photo_1, artwork_photo_2: artwork_photo_2}
    end

    test "without the artwork_id filter should return all artwork photos" do
      artwork_photos = ArtworkPhotos.list_artwork_photos()
      assert length(artwork_photos) == 2
    end

    test "with artwork_id filter should filter and return corresponding photos" do
      {:ok, artwork_2} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork_photo_1} =
        %{artwork_id: artwork_2.id} |> Factory.artwork_photo() |> Factory.insert()

      artwork_photos = ArtworkPhotos.list_artwork_photos(artwork_2.id)
      assert length(artwork_photos) == 1
      assert Enum.any?(artwork_photos, &(&1 == artwork_photo_1))
    end

    test "with artwork_id filter and preload=true should filter and return corresponding photos and preloaded artwork" do
      {:ok, artwork_2} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork_photo_1} =
        %{artwork_id: artwork_2.id} |> Factory.artwork_photo() |> Factory.insert()

      artwork_photos = ArtworkPhotos.list_artwork_photos(artwork_2.id, true)
      assert length(artwork_photos) == 1
      assert Enum.any?(artwork_photos, &(&1.id == artwork_photo_1.id))
      assert Enum.any?(artwork_photos, &(&1.artwork.id == artwork_2.id))
    end

    test "with unexistent artwork_id should return an empty list" do
      random_id = Ecto.UUID.generate()
      artwork_photos = ArtworkPhotos.list_artwork_photos(random_id)
      assert Enum.empty?(artwork_photos)
    end
  end

  describe "get_artwork_photo/1" do
    setup do
      {:ok, artwork} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork_photo} =
        %{artwork_id: artwork.id} |> Factory.artwork_photo() |> Factory.insert()

      {:ok, artwork: artwork, artwork_photo: artwork_photo}
    end

    test "with valid ID should return the given artwork photo", %{artwork_photo: artwork_photo} do
      assert ArtworkPhotos.get_artwork_photo(artwork_photo.id)
    end

    test "with unexistent id should return nil" do
      refute ArtworkPhotos.get_artwork_photo(Ecto.UUID.generate())
    end
  end

  describe "delete_artwork_photo/1" do
    setup do
      {:ok, artwork} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork_photo} =
        %{artwork_id: artwork.id} |> Factory.artwork_photo() |> Factory.insert()

      {:ok, artwork: artwork, artwork_photo: artwork_photo}
    end

    test "should delete the given artwork_photo", %{artwork_photo: artwork_photo} do
      ArtworkPhotos.delete_artwork_photo(artwork_photo)
      refute Repo.get(ArtworkPhoto, artwork_photo.id)
    end
  end
end
