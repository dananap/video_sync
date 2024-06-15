defmodule VideoSync.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :url, :string
      add :playing, :boolean, default: false, null: false
      add :time, :float

      timestamps(type: :utc_datetime)
    end
  end
end
