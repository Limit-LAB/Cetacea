defmodule UserInfoV1 do
  use Ecto.Schema

  @primary_key {:user_id, Ecto.UUID, autogenerate: {Uniq.UUID, :uuid7, []}}
  schema "user" do
    # field :user_id, :string, primary_key: true
    field :user_server, :string
    field :user_name, :string
    field :pubkey, :string
    field :avatar, :string
    field :bio, :string
    field :last_login_time, :utc_datetime
    field :last_update_time, :utc_datetime
    field :user_name_visibility, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
    field :avatar_visibility, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
    field :bio_visibility, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
    field :last_login_time_visibility, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
    field :last_update_time_visibility, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
    field :visibility, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
    # field :add_to_group, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
    # field :extension, :map
  end

  def encode(struct) do
    struct
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.delete(:id)
  end

  def self_encode(struct) do
    struct
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.delete(:id)
    |> Map.delete(:user_name_visibility)
    |> Map.delete(:avatar_visibility)
    |> Map.delete(:bio_visibility)
    |> Map.delete(:last_login_time_visibility)
    |> Map.delete(:last_update_time_visibility)
    |> Map.delete(:visibility)
  end
end

# def create_user_info_v1(user_name, user_server, avatar, bio) do
#   Cetacea.Repo.insert!(%UserInfoV1{
#     user_server: user_server,
#     user_name: user_name,
#     avatar: avatar,
#     bio: bio,
#     user_name_visibility: :Public,avatar_visibility: :Public,bio_visibility: :Public,last_login_time_visibility: :Public,last_update_time_visibility: :Public,visibility: :Public
#     })
# end

# defmodule UserHeaderV1 do
#   use Ecto.Schema

#   embedded_schema do
#     field :user_id, :id
#     field :user_server, :string
#   end
# end

# defmodule UserRecordV1 do
#   use Ecto.Schema

#   schema "user_record" do
#     # field :pinged_rooms, :string
#     embeds_many :last_reads, LastReadV1
#     field :user_info, :id
#     embeds_many :blocked_users, UserHeaderV1
#     embeds_many :friends, FriendV1
#   end
# end

defmodule LastReadV1 do
  use Ecto.Schema

  schema "user_last_read" do
    field :user_id, Ecto.UUID
    field :room_id, Ecto.UUID
    field :event_id, Ecto.UUID
  end

  def encode(struct) do
    struct
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.delete(:user_id)
  end
end

defmodule UserInfoV1 do
  use Ecto.Schema

  # @primary_key {:user_id, :integer, autogenerate: true}
  schema "block_list" do
    field :user_id, Ecto.UUID
    field :block_id, Ecto.UUID
  end

  def encode(struct) do
    struct.block_id
  end
end
defmodule FriendV1 do
  use Ecto.Schema

  schema "user_friend" do
    field :user_id, Ecto.UUID
    field :alias, :string
    field :friend_id, Ecto.UUID
    field :friend_since, :utc_datetime
  end

  def encode(struct) do
    struct
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.delete(:user_id)
  end
end

defmodule FriendTagV1 do
  use Ecto.Schema

  schema "friend_tag" do
    field :user_id, Ecto.UUID
    field :friend_id, Ecto.UUID
    field :tag, :string
  end

  def encode(struct) do
    struct.tag
  end
end
