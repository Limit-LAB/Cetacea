defmodule CetaceaWeb.UserTest do
  use CetaceaWeb.ConnCase, async: true

  defp api(path, body \\ nil) do
    build_conn()
    |> post(path, body)
    |> json_response(200)
  end

  defp invalid_args do
    Enum.shuffle([
      nil,
      :crypto.strong_rand_bytes(:rand.uniform(20)),
      :rand.uniform() * 100,
      [:fuck, :lemonhx]
    ])
  end

  test "Get User Info V1 with invalid arguments" do
    for a <- invalid_args() do
      body = api(~p"/api/user/user_info_v1/get", a)
      assert body["error_code"] && body["error_message"]

      for b <- invalid_args() do
        body = api(~p"/api/user/user_info_v1/get", %{user_id: a, user_server: b})
        assert body["error_code"] && body["error_message"]
      end
    end
  end

  test "Get Self Info V1 with invalid arguments" do
    for a <- invalid_args() do
      body = api(~p"/api/user/user_record_v1/get", a)
      assert body["error_code"] && body["error_message"]

      for b <- invalid_args() do
        body =
          api(~p"/api/user/user_record_v1/get", %{
            user: %{user_id: a, user_server: b},
            jwt_token: a
          })

        assert body["error_code"] && body["error_message"]
      end
    end
  end

  test "Set Self Info V1 with invalid arguments" do
    for a <- invalid_args() do
      body = api(~p"/api/user/user_record_v1/set", a)
      assert body["error_code"] && body["error_message"]

      for b <- invalid_args() do
        body =
          api(~p"/api/user/user_record_v1/set", %{
            user: %{user_id: a, user_server: b},
            jwt_token: a
          })

        assert body["error_code"] && body["error_message"]
      end
    end
  end
end
