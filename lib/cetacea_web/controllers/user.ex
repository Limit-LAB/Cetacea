import Plug.Conn
import Ecto.Query

defmodule CetaceaWeb.GetUserInfoV1 do
  use CetaceaWeb, :controller

  def create(conn, %{"user_id" => user_id, "user_server" => user_server}) do
    Cetacea.Repo.one(from u in UserInfoV1, where: u.user_id == ^user_id and u.user_server == ^user_server)
    |> case do
      nil -> json(conn, error_code: "UNKNOWN", error_message: "user is not exist")
      user -> json(conn, user)
    end
  end

  def create(conn, _params) do
    json(conn, %{error_code: "UNKNOWN", error_message: "params is not exist"})
  end
end

defmodule CetaceaWeb.GetSelfUserRecordV1 do
  use CetaceaWeb, :controller

  def create(conn, _params) do
    user = conn.assigns[:user]
    if user != nil do
      user_id = user["user_id"]
      # Cetacea.Repo.one(from u in UserRecordV1)
      json(conn, %{user_id: user_id})
    else
      json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is not exist"})
    end
  end
end

defmodule CetaceaWeb.SetSelfUserRecordV1 do
  use CetaceaWeb, :controller

  def create(conn, _params) do
    user = conn.assigns[:user]
    if user != nil do
      user_id = user.user_id
      # Cetacea.Repo.one(from u in UserRecordV1)
      # TODO
      json(conn, %{user_id: user_id})
    else
      json(conn, %{error_code: "InvalidJWTToken", error_message: "jwt token is not exist"})
    end
  end
end
