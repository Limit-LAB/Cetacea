import Plug.Conn
import Ecto.Query

defmodule CetaceaWeb.GetUserInfoV1 do
  use CetaceaWeb, :controller

  def create(conn, %{"user_id" => user_id, "user_server" => user_server}) do
    Cetacea.Repo.one(from u in UserInfoV1, where: u.user_id == ^user_id and u.user_server == ^user_server)
    |> case do
      nil -> json(conn, error_code: "UNKNOWN", error_message: "user is not exist")
      user -> json(conn, user)
    end
  end

  def create(conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is not exist"})
  end
end

defmodule CetaceaWeb.GetSelfUserRecordV1 do
  use CetaceaWeb, :controller

  def create(%Plug.Conn{assigns: %{"user" => %{"user_id" => user_id}}} = conn, _params) do
    # user_id = user["user_id"]
    user_info = Cetacea.Repo.one(from u in UserInfoV1)
    user_info = UserInfoV1.encode(user_info)
    last_reads = Cetacea.Repo.all(from u in LastReadV1, where: u.user_id == ^user_id)
    last_reads = Enum.map(last_reads, fn(last_read) -> LastReadV1.encode(last_read) end)
    json(conn, %{
      pinged_rooms: [],
      last_reads: last_reads,
      user_info: user_info,
      blocked_users: [],
      friends: [],
    })
  end

  def create(conn, _params) do
    json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is not exist"})
  end
end

defmodule CetaceaWeb.SetSelfUserRecordV1 do
  use CetaceaWeb, :controller

  "pinged_rooms: Vec<String>,
  last_reads: Vec<LastReadV1>,
  user_info: UserInfoV1,
  blocked_users: Vec<UserHeaderV1>,
  friends: Vec<Friend>,"

  def create(%Plug.Conn{assigns: %{"user" => %{"user_id" => user_id} = user}} = conn,
    %{
      # "user_id" => user_id,
      "pinged_rooms" => pinged_rooms,
      "last_reads" => last_reads,
      "blocked_users" => blocked_users,
      "friends" => friends
    }) do
      # Enum.each(list, fn(x) -> IO.puts(x) end)
      Enum.each(last_reads, fn(x) -> Cetacea.Repo.insert(%LastReadV1{
        user_id: user_id,
        event_id: x.event_id,
        room_id: x.room_id})
      end)
      Enum.each(friends, fn(x) ->
        id = Cetacea.Repo.insert(%FriendV1{
        user_id: user_id,
        alias: x.alias,
        friend_id: x.friend_id,
        friend_since: x.friend_since}).id
        Enum.each(x.tags, fn(tag) -> Cetacea.Repo.insert(%FriendTagV1{
          user_id: user_id,
          friend_id: id,
          tag: tag})
        end)
      end)
      json(conn, %{})
  end

  def create(conn, _params) do
    json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is not exist"})
  end
end
