defmodule Elmix.Metrology.Weather do
  use Ecto.Schema
  import Ecto.Changeset

  schema "samples" do
    field :cloudy, :boolean, default: false
    field :moisture, :integer
    field :temperatue, :integer

    timestamps()
  end

  @doc false
  def changeset(weather, attrs) do
    weather
    |> cast(attrs, [:temperatue, :moisture, :cloudy])
    |> validate_required([:temperatue, :moisture, :cloudy])
    |> validate_temperature(:temperature)
  end

  defp validate_temperature(changeset, field) do
    case changeset.valid? do
      true ->
        field = get_field(changeset, field)

        if field < 100 && field > -100 do
          changeset
        else
          add_error(changeset, :temperature, "Illegal temperature")
        end

      _ ->
        changeset
    end
  end
end
