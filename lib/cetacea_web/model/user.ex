defmodule UserInfoV1 do
  use Ecto.Schema

  schema "user" do
    field :user_id, :id, primary_key: true
    field :user_server, :string
    embeds_one :user_name, UserInfoFieldV1
    embeds_one :avatar, UserInfoFieldV1
    embeds_one :bio, UserInfoFieldV1
    field :visibility, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
    field :add_to_group, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
    # field :extension, :map
  end
end

defmodule UserHeaderV1 do
  use Ecto.Schema

  schema "user_header" do
    field :user_id, :id
    field :user_server, :string
  end
end

defmodule UserInfoFieldV1 do
  use Ecto.Schema

  embedded_schema do
    field :field, :string
    field :visibility, Ecto.Enum, values: [:Public, :OnlyToFriends, :NotAllow]
  end
end

defmodule UserRecordV1 do
  use Ecto.Schema

  schema "user_record" do
    field :last_login_ts, :utc_datetime
    field :pinged_rooms, {:array, :string}
    embeds_many :last_reads, LastReadV1
    has_one :user_info, UserInfoV1
    embeds_many :blocked_users, UserHeaderV1
    embeds_many :friends, FriendV1
  end
end

defmodule LastReadV1 do
  use Ecto.Schema

  embedded_schema do
    field :room_id, :string
    field :event_id, :string
  end
end

defmodule FriendV1 do
  use Ecto.Schema

  embedded_schema  do
    field :alias, :string
    has_one :user, UserInfoV1
    # field :last_login_ts, :utc_datetime
    field :friend_since, :utc_datetime
    field :tags, {:array, :string}
  end
end
