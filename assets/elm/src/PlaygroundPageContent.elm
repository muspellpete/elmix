module PlaygroundPageContent exposing (pageContent)

import Browser
import Html exposing (Html, a, button, div, table, td, text, th, tr)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Weather exposing (Model, Msg(..))


pageContent : Model -> Browser.Document Msg
pageContent _ =
    { title = "Elmix - Playground page"
    , body =
        [ div [ class "bg-green-200" ] [ button [ onClick Weather.RefreshData, class "bg-blue-400 m-b10" ] [ text "Back" ] ]
        , div [ class "my-10" ] [ text "Playground page" ]
        , div [ class "bg-yellow-200 my-10 text-orange-900 text-center p-4 w-20 rounded-full" ] [ text "Cake" ]
        , div [ class "text-left" ]
            [ createTable
                [ "This"
                , "StackOverflow"
                , "RPS"
                ]
                [ "http://10.0.0.131:4000/"
                , "https://stackoverflow.com/"
                , "https://www.rockpapershotgun.com/"
                ]
            ]
        ]
    }


createTable : List String -> List String -> Html Msg
createTable headers links =
    table [] (List.map2 createRow headers links)


createRow : String -> String -> Html Msg
createRow header content =
    tr []
        [ th [ class "w-40" ] [ text (header ++ ":") ]
        , td [ class "w-40" ] [ a [ href content ] [ div [ class "text-blue-700 hover:underline hover:text-red-600" ] [ text content ] ] ]
        ]
