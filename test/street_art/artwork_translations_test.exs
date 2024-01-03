defmodule StreetArt.ArtworkTranslation.ArtworkTranslationsTest do
  import Faker.Lorem, only: [paragraph: 0, word: 0]
  use ExUnit.Case, async: true
  use StreetArt.DataCase

  alias StreetArt.{Factory, Repo, ArtworkTranslation, ArtworkTranslation.ArtworkTranslations}

  describe "create_artwork_translation/1" do
    setup do
      {:ok, artwork} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork_translation} =
        %{artwork_id: artwork.id} |> Factory.artwork_translation() |> Factory.insert()

      {:ok, artwork: artwork, artwork_translation: artwork_translation}
    end

    test "with valid attrs should create an artwork translation", %{artwork: artwork} do
      attrs = %{
        locale: "fr",
        description: paragraph(),
        title: word(),
        artwork_id: artwork.id
      }

      {:ok, artwork_translation} = ArtworkTranslations.create_artwork_translation(attrs)
      assert artwork_translation.id
      assert artwork_translation.description == attrs.description
      assert artwork_translation.title == attrs.title
      assert artwork_translation.artwork_id == attrs.artwork_id
    end

    test "if given locale already exists for the artwork should not create and return an error",
         %{
           artwork: artwork
         } do
      attrs = %{
        locale: "en",
        title: word(),
        description: paragraph(),
        artwork_id: artwork.id
      }

      {:error, %Ecto.Changeset{errors: errors}} =
        ArtworkTranslations.create_artwork_translation(attrs)

      assert errors == [
               artwork_id:
                 {"has already been taken",
                  [
                    constraint: :unique,
                    constraint_name: "artwork_translations_artwork_id_locale_index"
                  ]}
             ]
    end

    test "without artwork_id should not create the translation and return an error" do
      attrs = %{
        locale: "FR",
        description: paragraph(),
        title: word()
      }

      {:error, %Ecto.Changeset{errors: errors}} =
        ArtworkTranslations.create_artwork_translation(attrs)

      assert errors == [artwork_id: {"can't be blank", [validation: :required]}]
    end

    test "with invalid locale should not create the translation and return an error",
         %{artwork: artwork} do
      attrs = %{
        locale: "FRA",
        description: paragraph(),
        title: word(),
        artwork_id: artwork.id
      }

      {:error, %Ecto.Changeset{errors: errors}} =
        ArtworkTranslations.create_artwork_translation(attrs)

      assert errors == [
               locale:
                 {"should be at most %{count} character(s)",
                  [{:count, 2}, {:validation, :length}, {:kind, :max}, {:type, :string}]}
             ]
    end
  end

  describe "update_artwork_translation/2" do
    setup do
      {:ok, artwork} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork_translation} =
        %{arwork_id: artwork.id} |> Factory.artwork_translation() |> Factory.insert()

      {:ok, artwork: artwork, artwork_translation: artwork_translation}
    end

    test "with valid attrs should update the given photo", %{
      artwork_translation: artwork_translation,
      artwork: artwork
    } do
      attrs = %{
        title: paragraph(),
        artwork_id: artwork.id
      }

      {:ok, updated_translation} =
        ArtworkTranslations.update_artwork_translation(artwork_translation, attrs)

      assert updated_translation.id == artwork_translation.id
      assert updated_translation.title == attrs.title
    end

    test "without artwork_id should not update and return an error", %{
      artwork_translation: artwork_translation
    } do
      attrs = %{
        title: paragraph()
      }

      {:error, %Ecto.Changeset{errors: errors}} =
        ArtworkTranslations.update_artwork_translation(artwork_translation, attrs)

      assert errors == [artwork_id: {"can't be blank", [validation: :required]}]
      refute artwork_translation.title == attrs.title
    end
  end

  describe "list_artwork_translations/2" do
    setup do
      {:ok, artwork_1} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork_translation_1} =
        %{artwork_id: artwork_1.id} |> Factory.artwork_translation() |> Factory.insert()

      {:ok, artwork_translation_2} =
        %{artwork_id: artwork_1.id, locale: "fr"}
        |> Factory.artwork_translation()
        |> Factory.insert()

      {:ok,
       artwork_1: artwork_1,
       artwork_translation_1: artwork_translation_1,
       artwork_translation_2: artwork_translation_2}
    end

    test "without the artwork_id filter should return all artwork translations" do
      artwork_translations = ArtworkTranslations.list_artwork_translations(%{})
      assert length(artwork_translations) == 2
    end

    test "with artwork_id filter should filter and return corresponding translations", %{
      artwork_1: artwork_1,
      artwork_translation_1: artwork_translation_1,
      artwork_translation_2: artwork_translation_2
    } do
      artwork_translations =
        ArtworkTranslations.list_artwork_translations(%{artwork_id: artwork_1.id})

      assert length(artwork_translations) == 2
      assert Enum.any?(artwork_translations, &(&1 == artwork_translation_1))
      assert Enum.any?(artwork_translations, &(&1 == artwork_translation_2))
    end

    test "with artwork_id and locale filter should filter and return corresponding translations",
         %{
           artwork_1: artwork_1,
           artwork_translation_1: artwork_translation_1,
           artwork_translation_2: artwork_translation_2
         } do
      artwork_translations =
        ArtworkTranslations.list_artwork_translations(%{
          artwork_id: artwork_1.id,
          locale: artwork_translation_1.locale
        })

      assert length(artwork_translations) == 1
      assert Enum.any?(artwork_translations, &(&1 == artwork_translation_1))
      refute Enum.any?(artwork_translations, &(&1 == artwork_translation_2))
    end

    test "with artwork_id filter and preload=true should filter and return corresponding translations and preloaded artwork",
         %{
           artwork_1: artwork_1,
           artwork_translation_1: artwork_translation_1,
           artwork_translation_2: artwork_translation_2
         } do
      artwork_translations =
        ArtworkTranslations.list_artwork_translations(%{artork_id: artwork_1.id}, true)

      assert length(artwork_translations) == 2
      assert Enum.any?(artwork_translations, &(&1.id == artwork_translation_1.id))
      assert Enum.any?(artwork_translations, &(&1.id == artwork_translation_2.id))
      assert Enum.any?(artwork_translations, &(&1.artwork.id == artwork_1.id))
    end

    test "with unexistent artwork_id should return an empty list" do
      random_id = Ecto.UUID.generate()

      artwork_translations =
        ArtworkTranslations.list_artwork_translations(%{artwork_id: random_id})

      assert Enum.empty?(artwork_translations)
    end
  end

  describe "get_artwork_translation/1" do
    setup do
      {:ok, artwork} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork_translation} =
        %{artwork_id: artwork.id} |> Factory.artwork_translation() |> Factory.insert()

      {:ok, artwork: artwork, artwork_translation: artwork_translation}
    end

    test "with valid ID should return the given artwork photo", %{
      artwork_translation: artwork_translation
    } do
      assert ArtworkTranslations.get_artwork_translation(artwork_translation.id)
    end

    test "with unexistent id should return nil" do
      refute ArtworkTranslations.get_artwork_translation(Ecto.UUID.generate())
    end
  end

  describe "delete_artwork_translation/1" do
    setup do
      {:ok, artwork} = %{} |> Factory.artwork() |> Factory.insert()

      {:ok, artwork_translation} =
        %{artwork_id: artwork.id} |> Factory.artwork_translation() |> Factory.insert()

      {:ok, artwork: artwork, artwork_translation: artwork_translation}
    end

    test "should delete the given artwork translation", %{
      artwork_translation: artwork_translation
    } do
      ArtworkTranslations.delete_artwork_translation(artwork_translation)
      refute Repo.get(ArtworkTranslation, artwork_translation.id)
    end
  end
end
