defmodule Stickerbooru.Repo.Migrations.CreateStickersets do
  use Ecto.Migration

  def change do
    create table(:stickersets) do
      add :name, :string, null: false
      add :thumbnail, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:stickersets, [:name])
  end
end
