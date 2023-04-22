defmodule CetaceaWeb.CreateRoomV1 do
  use CetaceaWeb, :controller

  def create(conn,params) do
    # user = conn.assigns[:user]
    json(conn, %{})
  end

  def create(conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is not exist"})
  end
end

defmodule CetaceaWeb.SyncRoomV1 do
  use CetaceaWeb, :controller

  def create(conn,params) do
    # user = conn.assigns[:user]
    json(conn, %{})
  end

  def create(conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is not exist"})
  end
end

defmodule CetaceaWeb.SendMessagesV1 do
  use CetaceaWeb, :controller

  def create(conn, params) do
    # user = conn.assigns[:user]
    json(conn, %{})
  end

  def create(conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is not exist"})
  end
end
