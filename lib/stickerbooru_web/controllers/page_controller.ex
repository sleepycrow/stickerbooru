defmodule StickerbooruWeb.PageController do
  use StickerbooruWeb, :controller
  alias Stickerbooru.StickerSet

  def home(conn, _params) do
    random = StickerSet.get_random(1) |> List.first()
    untagged = StickerSet.get_untagged(10)

    render(conn, :home, layout: false, untagged: untagged, random: random)
  end
end
