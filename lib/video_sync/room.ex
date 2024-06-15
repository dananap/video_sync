defmodule VideoSync.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room" do
    field :time, :float, default: 0.0
    field :url, :string
    field :playing, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:url, :playing, :time])
    |> validate_required([:url, :playing, :time])
  end
end
