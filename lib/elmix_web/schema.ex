defmodule ElmixWeb.Schema do
use Absinthe.Schema

alias ElmixWeb.Resolvers
# import types
import_types(ElmixWeb.Schema.Types)

query do
  @desc "Get a list of all weather samples"
  field :samples, list_of(:weather_type) do
    # Resolver
    resolve(&Resolvers.WeatherResolver.samples/3)
  end
end

#mutation do
#end

#subscriptions do
#end
end
