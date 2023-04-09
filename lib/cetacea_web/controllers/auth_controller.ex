# import Plug.Conn
# import Joken.Signer

defmodule CetaceaWeb.PubkeyLoginV1 do
  use CetaceaWeb, :controller

  @max_expire 24 * 60 * 60 * 1000
  @min_expire 1 * 60 * 60 * 1000

  def create(conn, %{"pubkey" => pubkey} = params) do
    secret_key_base = Application.get_env(:cetacea, CetaceaWeb.Endpoint)[:secret_key_base]

    expire =
      Map.get(params, "sign_jwt_duration", @max_expire)
      |> min(@max_expire)
      |> max(@min_expire)

    claims = %{"pubkey" => pubkey, "sign_jwt_duration" => expire}

    signer = Joken.Signer.create("HS256", secret_key_base)

    Cetacea.Token.generate_and_sign(claims, signer)
    |> case do
      {:ok, jwt, _} -> json(conn, %{jwt_token: jwt})
      {:error, msg} -> json(conn, %{error_code: "InvalidPubkey", error_message: msg})
    end
  end

  def create(conn, _params) do
    json(conn, %{error_code: "InvalidPubkey", error_message: "pubkey is not exist"})
  end
end

defmodule CetaceaWeb.JwtLoginV1 do
  use CetaceaWeb, :controller

  def create(conn, %{"jwt_token" => token} = _params) do
    secret_key_base = Application.get_env(:cetacea, CetaceaWeb.Endpoint)[:secret_key_base]
    signer = Joken.Signer.create("HS256", secret_key_base)

    Cetacea.Token.verify_and_validate(token, signer)
    |> case do
      {:ok, _} ->
        json(conn, %{})

      {:error, msg} ->
        json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is invalid: #{msg}"})
    end
  end

  def create(conn, _params) do
    json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is not exist"})
  end
end
