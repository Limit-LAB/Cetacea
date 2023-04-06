defmodule CetaceaWeb.HelloController do
  use CetaceaWeb, :controller

  def index(conn, _params) do
    json(conn, %{aaa: 114514})
  end
end
