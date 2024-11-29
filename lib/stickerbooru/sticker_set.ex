defmodule Stickerbooru.StickerSet do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias Stickerbooru.{Repo, Tag, TagStickerSetRelationship}

  schema "stickersets" do
    field :name, :string
    field :thumbnail, :string
    many_to_many :tags, Tag, join_through: TagStickerSetRelationship

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sticker_set, attrs) do
    sticker_set
    |> cast(attrs, [:name, :thumbnail])
    |> validate_required([:name, :thumbnail])
    |> unique_constraint(:name)
  end

  def create(params \\ %{}) do
    changeset =
      %__MODULE__{}
      |> changeset(params)

    if changeset.valid? do
      Repo.insert(changeset)
    else
      {:error, changeset}
    end
  end

  def get_by_id(id) do
    from(
      stickerset in __MODULE__,
      where: stickerset.id == ^id
    )
    |> Repo.one()
  end

  def get_by_name(name) do
    from(
      stickerset in __MODULE__,
      where: stickerset.name == ^name
    )
    |> Repo.one()
  end

  def get_untagged(max_amount) do
    from(
      stickerset in __MODULE__,
      left_join: rel in TagStickerSetRelationship, on: rel.stickerset_id == stickerset.id,
      where: is_nil(rel),
      order_by: [asc: stickerset.id],
      limit: ^max_amount
    )
    |> Repo.all()
  end

  def get_random(max_amount) do
    from(
      stickerset in __MODULE__,
      order_by: fragment("RANDOM()"),
      limit: ^max_amount
    )
    |> Repo.all()
  end
end
