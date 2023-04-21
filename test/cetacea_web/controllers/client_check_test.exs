defmodule CetaceaWeb.ClientCheckTest do
  use CetaceaWeb.ConnCase, async: true

  defp api(path, body \\ nil) do
    build_conn()
    |> post(path, body)
    |> json_response(200)
  end

  test "Client Check V1" do
    body = api(~p"/api/client_check_v1", %{"server_addr" => "example.com"})
    assert !body["error_code"]

    args = Enum.shuffle([nil, :rand.uniform() * 100, :crypto.strong_rand_bytes(20)])
    for arg <- args do
      body = api(~p"/api/client_check_v1", %{"server_addr" => args})
      assert body["error_code"] == "InvalidAddr"

      body = api(~p"/api/client_check_v1", args)
      assert body["error_code"] == "InvalidAddr"
    end
  end
end
