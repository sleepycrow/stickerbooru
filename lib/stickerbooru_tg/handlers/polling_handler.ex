defmodule StickerbooruTg.Handlers.PollingHandler do
  use Telegex.Polling.GenHandler
  alias Stickerbooru.StickerSet

  @impl true
  def on_boot() do
    # delete potential webhook, just in case
    {:ok, true} = Telegex.delete_webhook()

    %Telegex.Polling.Config{}
  end

  @impl true
  def on_update(%Telegex.Type.Update{message: %Telegex.Type.Message{
    chat: %Telegex.Type.Chat{} = chat,
    sticker: %Telegex.Type.Sticker{} = sticker
  }}) do
    IO.inspect("Got " <> sticker.emoji <> " from " <> sticker.set_name)

    with nil <- StickerSet.get_by_name(sticker.set_name),
         {:ok, stickerset} <- StickerSet.create(%{ name: sticker.set_name, thumbnail: sticker.file_id }) do
      Telegex.send_message(chat.id, "Sticker pack " <> sticker.set_name <> " inserted! It is now in the DB under the ID " <> Integer.to_string(stickerset.id))
    else
      %StickerSet{ id: id } -> Telegex.send_message(chat.id, "This sticker pack is already in the DB! It has the ID " <> Integer.to_string(id))
      {:error, _} -> Telegex.send_message(chat.id, "Failed to insert :(")
    end

    :ok
  end

  @impl true
  def on_update(_) do
    :ok
  end
end
