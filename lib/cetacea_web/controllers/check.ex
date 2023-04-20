defmodule CetaceaWeb.ClientCheckServerRequestV1 do
  use CetaceaWeb, :controller

  def create(conn, %{"server_addr" => server_addr}) do
    json(conn, %{
      server_version: "1",
      server_name: "demo",
      server_description: "demo server",
      supported_extensions: [],
      })
  end

  def create(conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "server_addr is not exist"})
  end
end
