defmodule Cetacea.Repo.Migrations.RoomTable do
  use Ecto.Migration

  def change do
    create table(:test_room) do
      add :room_id, :id, primary_key: true
      add :name, :string
      add :description, :string
      add :created_at, :utc_datetime
    end
    create table(:message) do
      add :message_id, :id, primary_key: true
      add :room_id, :id
      add :reply_to, :id
    end
    create table(:message_part) do
      add :message_id, :id
      add :type_, :string
      add :data, :string
    end
  end
end
