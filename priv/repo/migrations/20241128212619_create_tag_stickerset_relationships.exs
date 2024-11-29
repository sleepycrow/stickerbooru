defmodule Stickerbooru.Repo.Migrations.CreateTagStickersetRelationships do
  use Ecto.Migration

  def change do
    create table(:tag_stickerset_relationships) do
      add :tag_id, references(:tags, on_delete: :delete_all), null: false
      add :stickerset_id, references(:stickersets, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tag_stickerset_relationships, [:tag_id, :stickerset_id])
  end
end
