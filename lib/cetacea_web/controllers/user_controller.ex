import Plug.Conn


defmodule CetaceaWeb.GetSelfUserRecordV1 do
  use CetaceaWeb, :controller

  def create(conn, _params) do
    user = conn[:user]
    IO.puts("user:")
    IO.puts(user)
  end
end
