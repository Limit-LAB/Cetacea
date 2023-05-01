defmodule Cetacea.Repo.Migrations.UserTable do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :user_id, Ecto.UUID, primary_key: true, autogenerate: {Uniq.UUID, :uuid7, []}
      add :user_server, :string
      add :pubkey, :string
      add :user_name, :string
      add :avatar, :string
      add :bio, :string
      add :last_login_time, :utc_datetime
      add :last_update_time, :utc_datetime

      add :user_name_visibility, :string
      add :avatar_visibility, :string
      add :bio_visibility, :string
      add :last_login_time_visibility, :string
      add :last_update_time_visibility, :string
      add :visibility, :string
    end
    create table(:user_last_read) do
      add :user_id, Ecto.UUID
      add :room_id, Ecto.UUID
      add :event_id, Ecto.UUID
    end
    create table(:user_friend) do
      add :user_id, Ecto.UUID
      add :alias, :string
      add :friend_id, Ecto.UUID
      add :friend_since, :utc_datetime
    end
    create table(:friend_tag) do
      add :user_id, Ecto.UUID
      add :friend_id, Ecto.UUID
      add :friend_since, :utc_datetime
      add :tag, :string
    end
  end
end
