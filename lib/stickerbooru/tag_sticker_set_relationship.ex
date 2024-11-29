defmodule Stickerbooru.TagStickerSetRelationship do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tag_stickerset_relationships" do

    field :tag_id, :id
    field :stickerset_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tag_sticker_set_relationship, attrs) do
    tag_sticker_set_relationship
    |> cast(attrs, [:tag_id, :stickerset_id])
    |> validate_required([:tag_id, :stickerset_id])
    |> unique_constraint([:tag_id, :stickerset_id],
      name: :tag_stickerset_relationships_tag_id_stickerset_id_index,
      message: "already has tag"
    )
  end
end
