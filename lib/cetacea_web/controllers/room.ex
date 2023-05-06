import Ecto.Query

defmodule CetaceaWeb.CreateRoomV1 do
  use CetaceaWeb, :controller

  def create(conn, %{
    # "event_id" => event_id,
    # "event_type" => event_type,
    # "previous_event_id" => previous_event_id,
    # "extensions" => extensions,
    # "extensions_data" => extensions_data,
    # "inherit_from" => inherit_from,
  }) do
    # user = conn.assigns[:user]
    json(conn, %{})
  end

  def create(%Plug.Conn{assigns: %{"user" => %{"user_id" => _user_id}}} = conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is invalid"})
  end

  def create(conn, _params) do
    json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is not exist"})
  end
end

defmodule CetaceaWeb.SyncRoomV1 do
  use CetaceaWeb, :controller

  def create(%Plug.Conn{assigns: %{"user" => %{"user_id" => user_id} = user}} = conn, %{
    "room_id" => room_id,
    "From" => %{
      "from_event_id" => from_event_id,
    } = value,
  }) do
    limit = Map.get(value, "limit", nil)
    r = Cetacea.Repo.all(from m in MessageV1, where: m.message_id >= ^from_event_id, order_by: [desc: m.message_id], limit: ^limit)
    |> Enum.map(fn(message) ->
      MessageV1.encode(message) |> Map.put("message_parts",
      Cetacea.Repo.all(from m in MessagePartV1, where: m.message_id == ^message["message_id"])
      |> Enum.map(fn(message_part) -> MessagePartV1.encode(message_part) end)) end)
    json(conn, %{"messages" => r})
  end

  def create(%Plug.Conn{assigns: %{"user" => %{"user_id" => user_id} = user}} = conn, %{
    "room_id" => room_id,
    "To" => %{
      "to_event_id" => to_event_id,
    } = value,
  }) do
    limit = Map.get(value, "limit", nil)
    r = Cetacea.Repo.all(from m in MessageV1, where: m.message_id <= ^to_event_id, order_by: [desc: m.message_id], limit: ^limit)
    |> Enum.map(fn(message) ->
      MessageV1.encode(message) |> Map.put("message_parts",
      Cetacea.Repo.all(from m in MessagePartV1, where: m.message_id == ^message["message_id"])
      |> Enum.map(fn(message_part) -> MessagePartV1.encode(message_part) end)) end)
    json(conn, %{"messages" => r})
  end

  def create(%Plug.Conn{assigns: %{"user" => %{"user_id" => user_id} = user}} = conn, %{
    "room_id" => room_id,
    "Between" => %{
      "from_event_id" => from_event_id,
      "to_event_id" => to_event_id,
    }
  }) do
    r = Cetacea.Repo.all(from m in MessageV1, where: m.message_id >= ^from_event_id and m.message_id <= ^to_event_id, order_by: [desc: m.message_id])
    |> Enum.map(fn(message) ->
      MessageV1.encode(message) |> Map.put("message_parts",
      Cetacea.Repo.all(from m in MessagePartV1, where: m.message_id == ^message["message_id"])
      |> Enum.map(fn(message_part) -> MessagePartV1.encode(message_part) end)) end)
    json(conn, %{"messages" => r})
  end

  def create(%Plug.Conn{assigns: %{"user" => %{"user_id" => user_id} = user}} = conn, %{
    "room_id" => room_id,
    "Recent" => %{ "limit" => limit }
  }) do
    r = Cetacea.Repo.all(from m in MessageV1, order_by: [desc: m.message_id], limit: ^limit)
    |> Enum.map(fn(message) ->
      MessageV1.encode(message) |> Map.put("message_parts",
      Cetacea.Repo.all(from m in MessagePartV1, where: m.message_id == ^message["message_id"])
      |> Enum.map(fn(message_part) -> MessagePartV1.encode(message_part) end)) end)
    json(conn, %{"messages" => r})
  end

  def create(%Plug.Conn{assigns: %{"user" => %{"user_id" => _user_id}}} = conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is invalid"})
  end

  def create(conn, _params) do
    json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is not exist"})
  end
end

defmodule CetaceaWeb.SendMessagesV1 do
  use CetaceaWeb, :controller

  def create(%Plug.Conn{assigns: %{"user" => %{"user_id" => user_id} = user}} = conn, %{
    "room_id" => room_id,
    "messages" => messages,
  }) do
    Enum.each(messages, fn(message) ->
      message_id = Uniq.UUID.uuid7()
      Cetacea.Repo.insert(%MessageV1{
        message_id: message_id,
        sender: user_id,
        room_id: room_id,
        reply_to: message["reply_to"],
      })
      Enum.each(message["message_parts"], fn(message_part) ->
        Cetacea.Repo.insert(%MessagePartV1{
          message_id: message_id,
          type: message_part["type"],
          data: message_part["data"],
        })
      end)
    end)
    json(conn, %{})
  end

  def create(%Plug.Conn{assigns: %{"user" => %{"user_id" => _user_id}}} = conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is invalid"})
  end

  def create(conn, _params) do
    json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is not exist"})
  end
end
