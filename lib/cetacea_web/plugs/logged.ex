defmodule CetaceaWeb.Plugs.Logged do
  import Plug.Conn
  use CetaceaWeb, :controller

  def init(default), do: default

  def call(%Plug.Conn{params: %{"jwt_token" => token}} = conn, _opts) do
    import Plug.Conn
    # token = conn.params["jwt_token"]
    if token == nil do
      json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token js not exist"})
    end

    secret_key_base = Application.get_env(:cetacea, CetaceaWeb.Endpoint)[:secret_key_base]
    signer = Joken.Signer.create("HS256", secret_key_base)
    {state, claims} = Cetacea.Token.verify_and_validate(token, signer)

    # TODO: check Map.get(claims, "sign_jwt_duration")

    if state == :ok do
      assign(conn, :user, claims["payload"])
    else
      # json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is invalid"})
      conn
    end
  end

  def call(%Plug.Conn{params: _params} = conn, _opts) do
    # json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is not exist"})
    conn
  end
end
