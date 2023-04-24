# import UUID

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

  def create(conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is not exist"})
  end
end

defmodule CetaceaWeb.SyncRoomV1 do
  use CetaceaWeb, :controller

  def create(conn, params) do
    # user = conn.assigns[:user]
    json(conn, %{})
  end

  def create(conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is not exist"})
  end
end

defmodule CetaceaWeb.SendMessagesV1 do
  use CetaceaWeb, :controller

  def create(%Plug.Conn{assigns: %{"user" => %{"user_id" => user_id} = user}} = conn, %{
    "room_id" => room_id,
    "messages" => messages,
  }) do
    Enum.each(messages, fn(message) ->
      message_id = UUID.uuid4()
      Cetacea.Repo.insert(%MessageV1{
        message_id: message_id,
        sender: user_id,
        room_id: room_id,
        reply_to: message["reply_to"],
      })
      Enum.each(message["message_parts"], fn(message_part) ->
        Cetacea.Repo.insert(%MessagePartV1{
          message_id: message_id,
          type_: message_part["type_"],
          data: message_part["data"],
        })
      end)
    end)
    json(conn, %{})
  end

  def create(conn, %{
    "room_id" => _room_id,
    "messages" => _messages,
  }) do
    json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is not exist"})
  end

  def create(conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is not exist"})
  end
end
