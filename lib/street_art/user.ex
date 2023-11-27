defmodule StreetArt.User do
  use StreetArt.Schema
  import Ecto.Changeset
  alias StreetArt.Itinerary

  schema "users" do
    field(:email, :string)
    field(:facebook_id, :string)
    field(:first_name, :string)
    field(:google_id, :string)
    field(:last_name, :string)
    field(:password_hash, :string)
    field(:username, :string)
    field :password, :string, virtual: true

    has_many(:itinerary, Itinerary)
    timestamps()
  end

  @required_fields ~w(email password)a
  @optional_fields ~w()
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      attrs,
      @required_fields,
      @optional_fields
    ])
    |> validate_required([
      @required_fields
    ])
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case get_field(changeset, :password) do
      nil ->
        changeset

      password ->
        hashed_password = Bcrypt.hash_pwd_salt(password)
        put_change(changeset, :password_hash, hashed_password)
    end
  end
end
