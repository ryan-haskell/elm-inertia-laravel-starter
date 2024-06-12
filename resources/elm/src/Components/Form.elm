module Components.Form exposing (Field(..), view)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events


view :
    { intro : Maybe String
    , fields : List (Field msg)
    , button : { label : String, onClick : msg }
    , link : Maybe { label : String, url : String }
    }
    -> Html msg
view props =
    div [ Attr.class "w-full sm:max-w-md mt-6 px-6 py-4 bg-white shadow-md overflow-hidden sm:rounded-lg" ]
        [ case props.intro of
            Just message ->
                div [ Attr.class "mb-4 text-sm text-gray-600" ] [ text message ]

            Nothing ->
                text ""
        , Html.form [ Html.Events.onSubmit props.button.onClick ]
            (List.concat
                [ List.indexedMap viewField props.fields
                , [ viewControls props ]
                ]
            )
        ]


type Field msg
    = TextInput
        { id : String
        , label : String
        , value : String
        , onInput : String -> msg
        , required : Bool
        , error : Maybe String
        }
    | EmailInput
        { id : String
        , label : String
        , value : String
        , onInput : String -> msg
        , required : Bool
        , error : Maybe String
        }
    | PasswordInput
        { id : String
        , label : String
        , value : String
        , onInput : String -> msg
        , required : Bool
        , error : Maybe String
        }
    | Checkbox
        { label : String
        , value : Bool
        , onInput : Bool -> msg
        }


viewField : Int -> Field msg -> Html msg
viewField index field =
    case field of
        TextInput props ->
            viewInput (index == 0) "text" props

        EmailInput props ->
            viewInput (index == 0) "email" props

        PasswordInput props ->
            viewInput (index == 0) "password" props

        Checkbox props ->
            viewCheckbox (index == 0) props


viewInput :
    Bool
    -> String
    ->
        { id : String
        , label : String
        , value : String
        , onInput : String -> msg
        , required : Bool
        , error : Maybe String
        }
    -> Html msg
viewInput isFirstInputOnForm inputType props =
    div [ Attr.classList [ ( "mt-4", not isFirstInputOnForm ) ] ]
        [ label
            [ Attr.class "block font-medium text-sm text-gray-700"
            , Attr.for props.id
            ]
            [ span [] [ text props.label ] ]
        , input
            [ Attr.class "border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm mt-1 block w-full"
            , Attr.classList [ ( "border-red-300", props.error /= Nothing ) ]
            , Attr.id props.id
            , Attr.type_ inputType
            , Attr.autocomplete False
            , Attr.value props.value
            , Html.Events.onInput props.onInput
            , Attr.required props.required
            , Attr.autofocus isFirstInputOnForm
            ]
            []
        , viewError props.error
        ]


viewCheckbox :
    Bool
    ->
        { label : String
        , value : Bool
        , onInput : Bool -> msg
        }
    -> Html msg
viewCheckbox isFirstInputOnForm props =
    div [ Attr.classList [ ( "mt-4", not isFirstInputOnForm ) ] ]
        [ label [ Attr.class "flex items-center" ]
            [ input
                [ Attr.type_ "checkbox"
                , Attr.class "rounded border-gray-300 text-indigo-600 shadow-sm focus:ring-indigo-500"
                , Attr.checked props.value
                , Html.Events.onCheck props.onInput
                ]
                []
            , span
                [ Attr.class "ms-2 text-sm text-gray-600" ]
                [ text props.label ]
            ]
        ]


viewControls :
    { props
        | button : { label : String, onClick : msg }
        , link : Maybe { label : String, url : String }
    }
    -> Html msg
viewControls props =
    div
        [ Attr.class "flex items-center justify-end mt-4" ]
        [ case props.link of
            Nothing ->
                text ""

            Just link ->
                a
                    [ Attr.class "underline text-sm text-gray-600 hover:text-gray-900 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                    , Attr.href link.url
                    ]
                    [ text link.label ]
        , button
            [ Attr.type_ "submit"
            , Attr.class "inline-flex items-center px-4 py-2 bg-gray-800 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-gray-700 focus:bg-gray-700 active:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 transition ease-in-out duration-150 ms-4"
            ]
            [ text props.button.label ]
        ]


viewError : Maybe String -> Html msg
viewError error =
    case error of
        Just message ->
            div [ Attr.class "mt-2" ]
                [ p [ Attr.class "text-sm text-red-600" ] [ text message ]
                ]

        Nothing ->
            text ""
