module Main exposing (..)

import Html exposing (..)
import CustomScalarCodecs exposing {Id}
import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing {RootQuery}
import Graphql.SelectionSet as SelectionSet exposing {SelectionSet}

main =
 text "Hello from Elmo 2"

query: SelectionSet Response RootQuery
query = Query