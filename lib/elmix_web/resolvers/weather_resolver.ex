defmodule ElmixWeb.Resolvers.WeatherResolver do
  alias Elmix.Metrology

  def samples(_,_,_) do
    {:ok, Metrology.list_samples()}
  end
end
