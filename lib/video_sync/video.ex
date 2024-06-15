defmodule VideoSync.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :time, :float
    field :url, :string
    field :playing, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:url, :playing, :time])
    |> validate_required([:url, :playing, :time])
  end
end
