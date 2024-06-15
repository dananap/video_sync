defmodule VideoSync.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :ip, :string

      timestamps(type: :utc_datetime)
    end
  end
end
