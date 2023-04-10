defmodule CetaceaWeb.ErrorHTMLTest do
  use CetaceaWeb.ConnCase, async: true

  test "Pubkey Login V1" do
    body =
      build_conn()
      |> post(~p"/api/auth/pubkey_login_v1")
      |> json_response(200)

    assert body["error_code"] == "InvalidPubkey"
    assert body["error_message"] == "pubkey is not exist"

    body =
      build_conn()
      |> post(~p"/api/auth/pubkey_login_v1", %{pubkey: "fuck lemonhx", sign_jwt_duration: -1})
      |> json_response(200)

    assert body["jwt_token"]
  end

  test "JWT Login V1" do
    body =
      build_conn()
      |> post(~p"/api/auth/jwt_login_v1")
      |> json_response(200)

    assert body["error_code"] == "InvalidJWTToken"
    assert body["error_message"] == "jwt token is not exist"

    body =
      build_conn()
      |> post(~p"/api/auth/jwt_login_v1", %{jwt_token: "fuck lemonhx"})
      |> json_response(200)

    assert body["error_code"] == "InvalidJWTToken"
    assert body["error_message"] == "jwt token is invalid: signature_error"
  end

  test "Login" do
    jwt_token_body =
      build_conn()
      |> post(~p"/api/auth/pubkey_login_v1", %{pubkey: "fuck lemonhx", sign_jwt_duration: -1})
      |> json_response(200)

    body =
      build_conn()
      |> post(~p"/api/auth/jwt_login_v1", jwt_token_body)
      |> json_response(200)

    assert Enum.empty?(body)
  end
end
