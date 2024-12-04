defmodule StickerbooruWeb.StickersetController do
  use StickerbooruWeb, :controller
  alias Stickerbooru.StickerSet

  plug :get_stickerset_by_id when action in [:show]

  def show(%{assigns: %{stickerset: stickerset}} = conn, _params) do
    render(conn, :show, stickerset: stickerset)
  end

  defp get_stickerset_by_id(%{params: %{"id" => id}} = conn, _) do
    with %StickerSet{} = stickerset <- StickerSet.get_by_id(id) do
      assign(conn, :stickerset, stickerset)
    else
      _ -> raise StickerbooruWeb.ObjectNotFoundError
    end
  end

  defp get_stickerset_by_id(_, _) do
    raise StickerbooruWeb.ObjectNotFoundError
  end
end
