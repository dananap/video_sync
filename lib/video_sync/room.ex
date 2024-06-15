defmodule VideoSync.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room" do
    field :time, :float, default: 0.0
    field :url, :string, default: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8"
    field :playing, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:url, :playing, :time])
    |> validate_required([:playing, :time])
  end
end
