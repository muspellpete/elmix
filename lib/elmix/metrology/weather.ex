defmodule Elmix.Metrology.Weather do
  use Ecto.Schema
  import Ecto.Changeset

  schema "samples" do
    field :cloudy, :boolean, default: false
    field :moisture, :integer
    field :temperature, :integer

    timestamps()
  end

  @doc false
  def changeset(weather, attrs) do
    weather
    |> cast(attrs, [:temperature, :moisture, :cloudy])
    |> validate_required([:temperature, :moisture, :cloudy])
    |> validate_temperature
  end

  defp validate_temperature(
         %Ecto.Changeset{valid?: true, changes: %{temperature: temperature}} = changeset
       ) do
    # if temperature < 100 && temperature > -100 do
    # changeset
    # else
    # add_error(changeset, :temperature, "Illegal temperature")
    # end
    changeset = change(changeset, temperature: temperature + 1)
    newTemperature = get_field(changeset, :temperature)

    cond do
      newTemperature > 100 ->
        add_error(changeset, :temperature, "Temperature too high")

      newTemperature < -100 ->
        add_error(changeset, :temperature, "Temperature too low")

      true ->
        changeset
    end
  end

  defp validate_temperature(changeset) do
    changeset
  end
end
