defmodule Cetacea.Repo do
  use Ecto.Repo,
    otp_app: :cetacea,
    adapter: Ecto.Adapters.SQLite3
end
