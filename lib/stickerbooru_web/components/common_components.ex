defmodule StickerbooruWeb.CommonComponents do
  use Phoenix.Component
  use StickerbooruWeb, :verified_routes

  attr :stickerset, Stickerbooru.StickerSet, required: true

  def stickerset_item(assigns) do
    ~H"""
    <a
      href={~p"/stickersets/#{@stickerset.id}"}
      class="stickerset-item"
    >
      <img
        src={~p"/thumbs/#{@stickerset.id}"}
        alt={@stickerset.name}
      />

      <div class="stickerset-item__meta">
        <span class="name"><%= @stickerset.name %></span>
        <span class="id">(<%= @stickerset.id %>)</span>
      </div>
    </a>
    """
  end
end
