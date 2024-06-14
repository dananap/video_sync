defmodule VideoSync.Repo do
  use Ecto.Repo,
    otp_app: :video_sync,
    adapter: Ecto.Adapters.Postgres
end
