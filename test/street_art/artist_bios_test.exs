defmodule StreetArt.ArtistBio.ArtistBiosTest do
  use ExUnit.Case, async: true
  use StreetArt.DataCase
  alias StreetArt.{ArtistBio, ArtistBio.ArtistBios, Factory, Repo}

  import Faker.Lorem, only: [paragraph: 0]

  describe "list_artist_bios/2" do
    setup do
      {:ok, artist} = %{} |> Factory.artist() |> Factory.insert()
      {:ok, artist_bio} = %{artist_id: artist.id} |> Factory.artist_bio() |> Factory.insert()
      {:ok, artist: artist, artist_bio: artist_bio}
    end

    test "should list all artist_bios without any parameters", %{
      artist_bio: artist_bio
    } do
      {:ok, artist_2} = %{} |> Factory.artist() |> Factory.insert()

      {:ok, artist_2_bio} = %{artist_id: artist_2.id} |> Factory.artist_bio() |> Factory.insert()
      artist_bios = ArtistBios.list_artist_bios(%{}, false)
      assert length(artist_bios) == 2
      assert Enum.any?(artist_bios, &(&1 == artist_bio))
      assert Enum.any?(artist_bios, &(&1 == artist_2_bio))
    end

    test "should preload artist", %{
      artist_bio: artist_bio,
      artist: artist
    } do
      artist_bios = ArtistBios.list_artist_bios(%{}, true)
      assert length(artist_bios) == 1
      assert Enum.any?(artist_bios, &(&1.id == artist_bio.id))
      assert Enum.any?(artist_bios, &(&1.artist == artist))
    end

    test "should filter by artist id", %{
      artist: artist,
      artist_bio: artist_bio
    } do
      {:ok, artist_2} = %{} |> Factory.artist() |> Factory.insert()

      {:ok, artist_2_bio} = %{artist_id: artist_2.id} |> Factory.artist_bio() |> Factory.insert()
      artist_bios = ArtistBios.list_artist_bios(%{artist_id: artist_2.id}, false)
      assert length(artist_bios) == 1
      refute Enum.any?(artist_bios, &(&1 == artist_bio))
      assert Enum.any?(artist_bios, &(&1 == artist_2_bio))
      assert Enum.any?(artist_bios, &(&1.artist_id == artist_2.id))
      refute Enum.any?(artist_bios, &(&1.artist_id == artist.id))
    end

    test "should filter by locale", %{
      artist: artist,
      artist_bio: artist_bio
    } do
      {:ok, artist_2_bio} =
        %{artist_id: artist.id, locale: "es"} |> Factory.artist_bio() |> Factory.insert()

      artist_bios = ArtistBios.list_artist_bios(%{locale: "es"}, false)
      assert length(artist_bios) == 1
      refute Enum.any?(artist_bios, &(&1 == artist_bio))
      assert Enum.any?(artist_bios, &(&1 == artist_2_bio))
    end

    test "should filter by locale and artist id", %{
      artist: artist
    } do
      {:ok, artist_2_bio} =
        %{artist_id: artist.id, locale: "es"} |> Factory.artist_bio() |> Factory.insert()

      {:ok, artist_2} = %{} |> Factory.artist() |> Factory.insert()

      {:ok, another_bio} =
        %{artist_id: artist_2.id, locale: "es"} |> Factory.artist_bio() |> Factory.insert()

      artist_bios = ArtistBios.list_artist_bios(%{locale: "es", artist_id: artist_2.id}, false)
      assert length(artist_bios) == 1
      assert Enum.any?(artist_bios, &(&1 == another_bio))
      refute Enum.any?(artist_bios, &(&1 == artist_2_bio))
    end
  end

  describe "get_artist_bio/1" do
    setup do
      {:ok, artist} = %{} |> Factory.artist() |> Factory.insert()
      {:ok, artist_bio} = %{artist_id: artist.id} |> Factory.artist_bio() |> Factory.insert()

      {:ok, artist: artist, artist_bio: artist_bio}
    end

    test "should return the artist bio of the given id", %{artist_bio: artist_bio, artist: artist} do
      fetched_bio = ArtistBios.get_artist_bio(artist_bio.id)
      assert fetched_bio.id == artist_bio.id
      assert fetched_bio.artist_id == artist.id
    end

    test "should return nil if the given bio doesn't exist" do
      random_id = Ecto.UUID.generate()
      refute ArtistBios.get_artist_bio(random_id)
    end
  end

  describe "create_artist_bio" do
    setup do
      {:ok, artist} = %{} |> Factory.artist() |> Factory.insert()

      {:ok, artist: artist}
    end

    test "with valid attrs should create a bio", %{artist: artist} do
      attrs = %{
        artist_id: artist.id,
        locale: "en",
        bio_text: paragraph()
      }

      {:ok, bio} = ArtistBios.create_artist_bio(attrs)
      assert bio.id
      assert bio.artist_id == attrs.artist_id
      assert bio.locale == attrs.locale
      assert bio.bio_text == attrs.bio_text
    end

    test "with locale already exists for the given artist should not create a bio and return an error",
         %{artist: artist} do
      {:ok, _} = %{artist_id: artist.id, locale: "en"} |> Factory.artist_bio() |> Factory.insert()

      attrs = %{
        artist_id: artist.id,
        locale: "en",
        bio_text: paragraph()
      }

      {:error, %Ecto.Changeset{errors: errors}} = ArtistBios.create_artist_bio(attrs)

      assert errors == [
               {:artist_id,
                {"has already been taken",
                 [constraint: :unique, constraint_name: "artist_bios_artist_id_locale_index"]}}
             ]
    end

    test "with missing artist id should not create a bio and return an error" do
      attrs = %{
        locale: "en",
        bio_text: paragraph()
      }

      {:error, %Ecto.Changeset{errors: errors}} = ArtistBios.create_artist_bio(attrs)

      assert errors == [artist_id: {"can't be blank", [validation: :required]}]
    end

    test "with invalid locale length should not create a bio and return an error",
         %{artist: artist} do
      attrs = %{
        artist_id: artist.id,
        locale: "eng",
        bio_text: paragraph()
      }

      {:error, %Ecto.Changeset{errors: errors}} = ArtistBios.create_artist_bio(attrs)

      assert errors == [
               locale:
                 {"should be at most %{count} character(s)",
                  [{:count, 2}, {:validation, :length}, {:kind, :max}, {:type, :string}]}
             ]
    end
  end

  describe "update_artist_bio/2" do
    setup do
      {:ok, artist} = %{} |> Factory.artist() |> Factory.insert()
      {:ok, bio} = %{artist_id: artist.id} |> Factory.artist_bio() |> Factory.insert()
      {:ok, artist: artist, bio: bio}
    end

    test "with valid attrs can update the artist bio", %{artist: artist, bio: bio} do
      attrs = %{bio_text: paragraph()}

      {:ok, updated_bio} = ArtistBios.update_artist_bio(bio, attrs)

      assert updated_bio.id == bio.id
      assert updated_bio.bio_text == attrs.bio_text
      refute updated_bio.bio_text == bio.bio_text
      assert updated_bio.artist_id == artist.id
    end
  end

  describe "delete_artist_bio/1" do
    setup do
      {:ok, artist} = %{} |> Factory.artist() |> Factory.insert()
      {:ok, bio} = %{artist_id: artist.id} |> Factory.artist_bio() |> Factory.insert()
      {:ok, artist: artist, bio: bio}
    end

    test "should delete the given bio", %{bio: bio} do
      ArtistBios.delete_artist_bio(bio)
      refute Repo.get(ArtistBio, bio.id)
    end
  end
end
