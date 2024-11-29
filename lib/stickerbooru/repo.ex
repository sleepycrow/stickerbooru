defmodule Stickerbooru.Repo do
  use Ecto.Repo,
    otp_app: :stickerbooru,
    adapter: Ecto.Adapters.Postgres
end
