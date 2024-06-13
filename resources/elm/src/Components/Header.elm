module Components.Header exposing (view)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)


view : { title : String, subtitle : String } -> Html msg
view props =
    div [ class "mb-6" ]
        [ h2 [ class "text-lg font-medium text-gray-900" ]
            [ text props.title ]
        , p [ class "mt-1 text-sm text-gray-600" ]
            [ text props.subtitle ]
        ]
