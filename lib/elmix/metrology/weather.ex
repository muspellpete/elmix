defmodule Elmix.Metrology.Weather do
  use Ecto.Schema
  import Ecto.Changeset

  schema "samples" do
    field :cloudy, :boolean, default: false
    field :moisture, :string
    field :temperatue, :string

    timestamps()
  end

  @doc false
  def changeset(weather, attrs) do
    weather
    |> cast(attrs, [:temperatue, :moisture, :cloudy])
    |> validate_required([:temperatue, :moisture, :cloudy])
  end
end
