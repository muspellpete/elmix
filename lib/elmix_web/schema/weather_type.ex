defmodule ElmixWeb.Schema.Types.Weathertype do
  use Absinthe.Schema.Notation

  object :weather_type do
    field(:id, :id)
    field(:temperature, :integer)
    field(:moisture, :integer)
    field(:cloudy, :boolean)
  end

  input_object :weather_input_type do
    field(:temperature, non_null(:integer))
    field(:moisture, non_null(:integer))
    field(:cloudy, non_null(:boolean))
  end
end
