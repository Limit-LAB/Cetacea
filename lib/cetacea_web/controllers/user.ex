import Plug.Conn

defmodule CetaceaWeb.GetUserInfoV1 do
  use CetaceaWeb, :controller

  def create(conn, %{"user_id" => user_id, "user_server" => user_server}) do
    # user = conn.assigns[:user]
    json(conn, %{user_id: user_id})
  end

  def create(conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is not exist"})
  end
end


defmodule CetaceaWeb.GetSelfUserRecordV1 do
  use CetaceaWeb, :controller

  def create(conn, _params) do
    user = conn.assigns[:user]
    IO.puts("user:")
    json(conn, %{user: user})
  end
end


defmodule CetaceaWeb.SetSelfUserRecordV1 do
  use CetaceaWeb, :controller

  def create(conn, _params) do
    user = conn.assigns[:user]
    IO.puts("user:")
    json(conn, %{user: user})
  end
end
