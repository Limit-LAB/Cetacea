defmodule TestRoom do
  use Ecto.Schema

  @primary_key {:room_id, Ecto.UUID, autogenerate: {Uniq.UUID, :uuid7, []}}
  schema "test_room" do
    # field :room_id, :id, primary_key: true
    # field :room_version, :string
    field :name, :string
    field :description, :string
    # field :avatar, :string
    # field :join_rule, RoomJoinRuleV1
    # field :join_restriction, Vec<RoomJoinRestrictionV1>
    field :created_at, :utc_datetime
    # embeds_many :members, UserHeaderV1
    # embeds_many :admins, UserHeaderV1
    # embeds_many :banned_members, UserHeaderV1
    # field :default_admin_abilities, Vec<AdminAbilitiesV1>
    # field :default_member_abilities, Vec<AdminAbilitiesV1>
    # embeds_many :messages, MessageV1
  end
end

defmodule MessageV1 do
  use Ecto.Schema

  @primary_key {:message_id, Ecto.UUID, autogenerate: {Uniq.UUID, :uuid7, []}}
  schema "message" do
    # field :message_id, :string#, primary_key: true
    field :sender, :string
    field :room_id, :string
    field :reply_to, :string
  end

  def encode(struct) do
    struct
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.delete(:room_id)
    # |> Map.delete(:message_id)
  end
end

defmodule MessagePartV1 do
  use Ecto.Schema

  schema "message_part" do
    field :message_id, Ecto.UUID
    field :type, :string
    field :data, :string
  end

  def encode(struct) do
    struct
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.delete(:message_id)
  end
end
