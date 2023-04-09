import Plug.Conn

defmodule CetaceaWeb.GetSelfUserRecordV1 do
  use CetaceaWeb, :controller

  def create(conn, _params) do
    user = conn.assigns[:user]
    IO.puts("user:")
    json(conn, %{user: user})
  end
end
