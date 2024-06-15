defmodule VideoSync.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :url, :string
      add :time, :string

      timestamps(type: :utc_datetime)
    end
  end
end
