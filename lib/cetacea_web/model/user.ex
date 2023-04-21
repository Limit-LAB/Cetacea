defmodule UserInfoV1 do
  use Ecto.Schema

  schema "user" do
    field :user_id, :id, primary_key: true
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


defmodule UserHeaderV1 do
  use Ecto.Schema

  embedded_schema do
    field :user_id, :id
    field :user_server, :string
  end
end

# defmodule UserInfoFieldV1 do
#   use Ecto.Schema

#   embedded_schema do
#     field :field, :string
#     field :visibility, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
#   end
# end

# defmodule UserDatetimeFieldV1 do
#   use Ecto.Schema

#   embedded_schema do
#     field :field, :utc_datetime
#     field :visibility, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
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
    field :user_id, :id
    field :room_id, :id
    field :event_id, :id
  end
end

defmodule FriendV1 do
  use Ecto.Schema

  schema "user_friend" do
    field :user_id, :id
    field :alias, :string
    field :friend_id, :id
    field :friend_since, :utc_datetime
  end
end

defmodule FriendTagV1 do
  use Ecto.Schema

  schema "friend_tag" do
    field :user_id, :id
    field :friend_id, :id
    field :friend_since, :utc_datetime
    field :tag, :string
  end
end
