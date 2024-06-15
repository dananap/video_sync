defmodule VideoSync.Player.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :time, :string
    field :url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:url, :time])
    |> validate_required([:url, :time])
  end
end
