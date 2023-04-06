import Plug.Conn
# import Joken.Signer

defmodule CetaceaWeb.JwtLoginV1 do
  use CetaceaWeb, :controller

  def create(conn, params) do
    pubkey = params["pubkey"]
    secret_key_base = "114514"
    # nt = params["nt"]
    nt = if params["nt"] == nil do
      2 * 60 * 60 * 1000
    else
      params["nt"]
    end
    # jwt = Joken.Signer.sign(%{pubkey:pubkey, nt: nt}, Joken.Signer.create("HS256", secret_key_base))
    claims = %{"pubkey" => pubkey, "nt" => nt}
    # %{key:pubkey, nt: nt}
    signer = Joken.Signer.create("HS256", secret_key_base)
    {:ok, jwt, claims} = Cetacea.Token.generate_and_sign(claims, signer)
    json(conn, %{jwt: jwt})
  end
end
