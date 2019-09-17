-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.ScalarCodecs exposing (Id, codecs)

import Api.Scalar exposing (defaultCodecs)
import Json.Decode as Decode exposing (Decoder)


type alias Id =
    Api.Scalar.Id


codecs : Api.Scalar.Codecs Id
codecs =
    Api.Scalar.defineCodecs
        { codecId = defaultCodecs.codecId
        }