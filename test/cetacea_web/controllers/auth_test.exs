defmodule CetaceaWeb.ErrorHTMLTest do
  use CetaceaWeb.ConnCase, async: true

  defp api_auth(path, body \\ nil) do
    build_conn()
    |> post(path, body)
    |> json_response(200)
  end

  test "Invalid Pubkey Login V1" do
    body = api_auth(~p"/api/auth/pubkey_login_v1")
    assert body["error_code"] == "InvalidPubkey"
    assert body["error_message"] == "pubkey is not exist"

    gen_invalid_pubkey = fn ->
      len = :rand.uniform(1000)
      :crypto.strong_rand_bytes(if len == 255, do: len + 1, else: len)
    end

    for a <- Enum.shuffle([nil, gen_invalid_pubkey.(), :rand.uniform() * 10000]) do
      for b <- Enum.shuffle([nil, gen_invalid_pubkey.(), trunc(:rand.uniform() * 10000)]) do
        body = api_auth(~p"/api/auth/pubkey_login_v1", %{pubkey: a, sign_jwt_duration: b})
        assert body["error_code"] == "InvalidPubkey", "expect error occurred"
      end
    end
  end

  test "Invalid JWT Login V1" do
    body = api_auth(~p"/api/auth/jwt_login_v1")
    assert body["error_code"] == "InvalidJWTToken"
    assert body["error_message"] == "jwt token is not exist"

    for a <-
          Enum.shuffle([
            nil,
            :crypto.strong_rand_bytes(:rand.uniform(1000)),
            :rand.uniform() * 10000
          ]) do
      body = api_auth(~p"/api/auth/jwt_login_v1", %{jwt_token: a})
      assert body["error_code"] == "InvalidJWTToken"
    end
  end

  test "Login V1" do
    jwt_token_body =
      api_auth(~p"/api/auth/pubkey_login_v1", %{
        pubkey: :crypto.strong_rand_bytes(255),
        sign_jwt_duration: -1
      })

    body = api_auth(~p"/api/auth/jwt_login_v1", jwt_token_body)
    assert Enum.empty?(body)
  end
end
