defmodule Cetacea.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cetacea.User

  schema "users" do
    field :pubkey, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:pubkey])
    |> validate_required([:pubkey])
  end
end
