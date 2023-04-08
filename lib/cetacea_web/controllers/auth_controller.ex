import Plug.Conn
# import Joken.Signer

defmodule CetaceaWeb.PubkeyLoginV1 do
  use CetaceaWeb, :controller

  def create(conn, params) do
    pubkey = params[:pubkey]
    secret_key_base = Application.get_env(:cetacea, CetaceaWeb.Endpoint)[:secret_key_base]
    nt = if params["sign_jwt_duration"] == nil do
      24 * 60 * 60 * 1000
    else
      params["sign_jwt_duration"]
    end

    claims = %{"pubkey" => pubkey, "sign_jwt_duration" => nt}

    signer = Joken.Signer.create("HS256", secret_key_base)
    {state, jwt, _claims} = Cetacea.Token.generate_and_sign(claims, signer)
    if state == :ok do
      json(conn, %{jwt_token: jwt})
    else
      json(conn, %{error_code: "InvalidPubkey", error_message: ""})
    end
  end
end

defmodule CetaceaWeb.JwtLoginV1 do
  use CetaceaWeb, :controller

  def create(conn, params) do
    token = params[:jwt_token]
    IO.puts(token)
    # header = params["header"]
    if token == nil do
      json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token js not exist"})
    end
    secret_key_base = Application.get_env(:cetacea, CetaceaWeb.Endpoint)[:secret_key_base]
    signer = Joken.Signer.create("HS256", secret_key_base)
    {state, _claims} = Cetacea.Token.verify_and_validate(token, signer)
    if state == :ok do
      json(conn, %{})
    else
      json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is invalid"})
    end
  end
end
