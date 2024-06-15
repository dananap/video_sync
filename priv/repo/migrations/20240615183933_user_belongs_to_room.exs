defmodule VideoSync.Repo.Migrations.UserBelongsToRoom do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :room_id, references(:room)
    end
  end
end
