defmodule TestRoom do
  use Ecto.Schema

  schema "test_room" do
    field :room_id, :id, primary_key: true
    field :room_version, :string
    field :name, :string
    field :description, :string
    field :avatar, :string
    # field :join_rule, RoomJoinRuleV1
    # field :join_restriction, Vec<RoomJoinRestrictionV1>
    field :created_at, :utc_datetime
    embeds_many :members, UserHeaderV1
    embeds_many :admins, UserHeaderV1
    embeds_many :banned_members, UserHeaderV1
    # field :default_admin_abilities, Vec<AdminAbilitiesV1>
    # field :default_member_abilities, Vec<AdminAbilitiesV1>
    embeds_many :messages, MessageV1
  end
end

defmodule MessageV1 do
  use Ecto.Schema

  embedded_schema do
    field :reply_to, :id
    embeds_many :message_parts, MessagePartV1
  end
end

defmodule MessagePartV1 do
  use Ecto.Schema

  embedded_schema do
    field :type_, :string
    field :data, :string
  end
end
