defmodule StreetArt.Artist.ArtistsTest do
  use ExUnit.Case, async: true
  use StreetArt.DataCase

  alias StreetArt.{Factory, Repo, Artist, Artist.Artists}

  describe "create_artist/1" do
    test "with valid attrs should create an artist" do
      attrs = %{
        first_name: "foo",
        last_name: "bar",
        avatar: "url/to/avatar.png",
        website_url: "https://www.testing.com"
      }

      {:ok, artist} = Artists.create_artist(attrs)
      assert artist.id
      assert artist.first_name == attrs.first_name
      assert artist.last_name == attrs.last_name
      assert Repo.get(Artist, artist.id)
    end

    test "without first_name or last_name should create an artist, returning unknown for respective fields" do
      {:ok, artist} = Artists.create_artist(%{})
      assert artist.id
      assert artist.first_name == "unknown"
      assert artist.last_name == "unknown"
      assert Repo.get(Artist, artist.id)
    end
  end

  describe "update_artist/2" do
    setup do
      {:ok, artist} = %{} |> Factory.artist() |> Factory.insert()

      {:ok, artist: artist}
    end

    test "with valid attrs should update the given artist", %{artist: artist} do
      attrs = %{
        first_name: "update foo",
        last_name: "update bar"
      }

      {:ok, updated_artist} = Artists.update_artist(artist, attrs)
      assert updated_artist.id == artist.id
      assert updated_artist.first_name == attrs.first_name
      assert updated_artist.last_name == attrs.last_name
    end

    test "with invalid attrs should not update the given artist and return an error", %{
      artist: artist
    } do
      attrs = %{foo: "bar"}
      {:error, %Ecto.Changeset{errors: errors}} = Artists.update_artist(artist, attrs)
      assert length(errors) > 0
    end

    test "with empty attrs should not update the given artist and return an error", %{
      artist: artist
    } do
      {:error, %Ecto.Changeset{errors: errors}} = Artists.update_artist(artist, %{})
      assert length(errors) > 0
    end
  end

  describe "list_artists/0" do
    test "should list all artists" do
      1..5
      |> Enum.each(fn _ -> {:ok, _} = %{} |> Factory.artist() |> Factory.insert() end)

      artists = Artists.list_artists()
      assert length(artists) == 5
    end

    test "when there's no artist should return an empty list" do
      artists = Artists.list_artists()
      assert length(artists) == 0
    end
  end

  describe "get_artist/1" do
    setup do
      {:ok, artist} = %{} |> Factory.artist() |> Factory.insert()

      {:ok, artist: artist}
    end

    test "with existing id should return the artist", %{artist: artist} do
      assert Artists.get_artist(artist.id)
    end

    test "unexistent id should return nil" do
      random_id = Ecto.UUID.generate()
      refute Artists.get_artist(random_id)
    end
  end

  describe "delete_artist/1" do
    setup do
      {:ok, artist} = %{} |> Factory.artist() |> Factory.insert()

      {:ok, artist: artist}
    end

    test "should delete the existing artist", %{artist: artist} do
      Artists.delete_artist(artist)
      refute Repo.get(Artist, artist.id)
    end
  end
end
