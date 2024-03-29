defmodule CetaceaWeb.Router do
  use CetaceaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CetaceaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :loginedapi do
    plug :accepts, ["json"]
    plug CetaceaWeb.Plugs.Logged
  end

  scope "/api", CetaceaWeb do
    pipe_through :api

    post "/client_check_v1", ClientCheckServerRequestV1, :create

    post "/auth/pubkey_login_v1", PubkeyLoginV1, :create
    post "/auth/jwt_login_v1", JwtLoginV1, :create

    post "/user/user_info_v1/get", GetUserInfoV1, :create
  end

  scope "/api", CetaceaWeb do
    pipe_through :loginedapi
    post "/user/user_record_v1/get", GetSelfUserRecordV1, :create
    post "/user/user_record_v1/set", SetSelfUserRecordV1, :create

    post "/client/room_v1/create", CreateRoomV1, :create
    post "/client/room_v1/<roomid>/sync", SyncRoomV1, :create
    post "/client/room_v1/<roomid>/send_messages", SendMessagesV1, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", CetaceaWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:cetacea, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CetaceaWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
