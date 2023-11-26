defmodule StreetArt.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :email, :string
      add :password_hash, :string
      add :google_id, :string
      add :facebook_id, :string
      add :first_name, :string
      add :last_name, :string
      add :username, :string

      timestamps()
    end
  end
end
