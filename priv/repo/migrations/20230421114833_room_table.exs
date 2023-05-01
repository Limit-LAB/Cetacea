defmodule Cetacea.Repo.Migrations.RoomTable do
  use Ecto.Migration

  def change do
    create table(:test_room) do
      add :room_id, Ecto.UUID, primary_key: true
      add :name, :string
      add :description, :string
      add :created_at, :utc_datetime
    end
    create table(:message) do
      add :message_id, Ecto.UUID, primary_key: true
      add :room_id, Ecto.UUID
      add :reply_to, Ecto.UUID
    end
    create table(:message_part) do
      add :message_id, Ecto.UUID
      add :type, :string
      add :data, :string
    end
  end
end
