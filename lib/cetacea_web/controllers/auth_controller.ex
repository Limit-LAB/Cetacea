import Plug.Conn
import Joken.Signer

defmodule CetaceaWeb.JwtLoginV1 do
  use CetaceaWeb, :controller

  def create(conn, params) do
    pubkey = params["pubkey"]
    secret_key_base = "114514"
    nt = params["nt"]
    if params["nt"] == nil do
      nt = 2 * 60 * 60 * 1000
    end
    jwt = Joken.Signer.sign(%{pubkey:pubkey, nt: nt}, Joken.Signer.create("HS256", secret_key_base))
    json(conn, %{jwt: jwt})
  end
end
