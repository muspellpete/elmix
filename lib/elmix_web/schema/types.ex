defmodule ElmixWeb.Schema.Types do
  use Absinthe.Schema.Notation

  alias ElmixWeb.Schema.Types

  import_types(Types.Weathertype)
end
