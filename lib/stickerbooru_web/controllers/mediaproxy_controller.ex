defmodule StickerbooruWeb.MediaProxyController do
  use StickerbooruWeb, :controller
  alias Stickerbooru.StickerSet

  def stickerset_thumbnail(conn, %{"id" => id}) do
    with %StickerSet{} = stickerset <- StickerSet.get_by_id(id),
         {:ok, %Telegex.Type.File{} = file} <- Telegex.get_file(stickerset.thumbnail),
         {:ok, %Finch.Response{} = resp} <- fetch_file(file.file_path) do
      file_name =
        String.split(file.file_path, "/")
        |> List.last()
      {_, file_type} = Enum.find(resp.headers, &(elem(&1, 0) == "content-type"))

      IO.inspect("Proxying " <> file_name <> " as thumb for sticker pack ID " <> id)

      conn
      |> send_download(
        {:binary, resp.body},
        filename: file_name,
        content_type: file_type,
        disposition: :attachment
      )
    else
      _ -> Plug.Conn.send_resp(conn, 404, "Not found")
    end
  end

  defp fetch_file(path) do
    Finch.build(:get, "https://api.telegram.org/file/bot#{Telegex.Global.token()}/#{path}")
    |> Finch.request(Stickerbooru.Finch)
  end
end
