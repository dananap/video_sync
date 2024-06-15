defmodule VideoSync.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :ip, :string
    belongs_to :room, VideoSync.Room

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :ip, :room_id])
    |> validate_required([:ip])
  end
end
