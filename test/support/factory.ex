defmodule StreetArt.Factory do
  import Faker.Person, only: [first_name: 0, last_name: 0]
  import Faker.Internet, only: [url: 0, image_url: 0]
  import Faker.Lorem, only: [paragraph: 0, word: 0]
  import Faker.Address, only: [street_address: 0, city: 0, country: 0, postcode: 0]
  alias StreetArt.{Repo, Artist, ArtistBio, Artwork, ArtworkPhoto, ArtworkTranslation}

  def insert(struct) do
    struct
    |> Repo.insert()
  end

  def artist(attrs \\ %{}) do
    %Artist{
      first_name: first_name(),
      last_name: last_name(),
      avatar: image_url(),
      website_url: url()
    }
    |> Map.merge(attrs)
  end

  def artist_bio(attrs \\ %{}) do
    %ArtistBio{
      locale: "en",
      bio_text: paragraph()
    }
    |> Map.merge(attrs)
  end

  def artwork(attrs \\ %{}) do
    %Artwork{
      address: street_address(),
      city: city(),
      country: country(),
      postal_code: postcode()
    }
    |> Map.merge(attrs)
  end

  def artwork_photo(attrs \\ %{}) do
    %ArtworkPhoto{
      is_main: false,
      photo_url: image_url()
    }
    |> Map.merge(attrs)
  end

  def artwork_translation(attrs \\ %{}) do
    %ArtworkTranslation{
      title: word(),
      locale: "en",
      description: paragraph()
    }
    |> Map.merge(attrs)
  end
end
