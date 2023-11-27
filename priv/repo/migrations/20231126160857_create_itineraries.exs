defmodule StreetArt.Repo.Migrations.CreateItineraries do
  use Ecto.Migration

  def change do
    create table(:itineraries, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :user_id, references(:users, type: :uuid)
      add :title, :string
      add :description, :text

      timestamps()
    end
  end
end
