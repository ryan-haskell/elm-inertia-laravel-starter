module Components.Form exposing
    ( Controls(..)
    , Field(..)
    , view
    )

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events


type Controls msg
    = ControlsRight
        { button : { label : String, onClick : msg }
        , link : Maybe { label : String, url : String }
        }
    | ControlsLeft
        { button :
            { label : String
            , onClick : msg
            }
        , message : Maybe String
        }


view :
    { autofocusFirstField : Bool
    , fields : List (Field msg)
    , controls : Controls msg
    }
    -> Html msg
view props =
    let
        onSubmit =
            case props.controls of
                ControlsLeft { button } ->
                    button.onClick

                ControlsRight { button } ->
                    button.onClick
    in
    Html.form [ Html.Events.onSubmit onSubmit ]
        (List.concat
            [ List.indexedMap (viewField props.autofocusFirstField) props.fields
            , [ viewControls props.controls ]
            ]
        )


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


viewField : Bool -> Int -> Field msg -> Html msg
viewField autofocusFirstField index field =
    let
        fieldProps : FieldProps
        fieldProps =
            { autofocusFirstField = autofocusFirstField, isFirstInputOnForm = index == 0 }
    in
    case field of
        TextInput props ->
            viewInput fieldProps "text" props

        EmailInput props ->
            viewInput fieldProps "email" props

        PasswordInput props ->
            viewInput fieldProps "password" props

        Checkbox props ->
            viewCheckbox fieldProps props


type alias FieldProps =
    { autofocusFirstField : Bool
    , isFirstInputOnForm : Bool
    }


viewInput :
    FieldProps
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
viewInput field inputType props =
    div [ Attr.classList [ ( "mt-4", not field.isFirstInputOnForm ) ] ]
        [ label
            [ Attr.class "block font-medium text-sm text-gray-700"
            , Attr.for props.id
            ]
            [ span [] [ text props.label ] ]
        , input
            [ Attr.class "border-gray-300 focus:border-indigo-500 focus:ring-indigo-500 rounded-md shadow-sm mt-1 block w-full"
            , Attr.id props.id
            , Attr.type_ inputType
            , Attr.autocomplete False
            , Attr.value props.value
            , Html.Events.onInput props.onInput
            , Attr.required props.required
            , Attr.autofocus (field.autofocusFirstField && field.isFirstInputOnForm)
            ]
            []
        , viewError props.error
        ]


viewCheckbox :
    FieldProps
    ->
        { label : String
        , value : Bool
        , onInput : Bool -> msg
        }
    -> Html msg
viewCheckbox { isFirstInputOnForm } props =
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


viewControls : Controls msg -> Html msg
viewControls controls =
    case controls of
        ControlsLeft props ->
            div [ Attr.class "flex items-center gap-4 mt-4" ]
                [ button
                    [ Attr.class "inline-flex items-center px-4 py-2 bg-gray-800 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-gray-700 focus:bg-gray-700 active:bg-gray-900 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 transition ease-in-out duration-150"
                    , Attr.type_ "submit"
                    ]
                    [ text props.button.label ]
                , case props.message of
                    Just message ->
                        p [ Attr.class "text-sm text-gray-600" ] [ text message ]

                    Nothing ->
                        text ""
                ]

        ControlsRight props ->
            viewControlsRight props


viewControlsRight :
    { button : { label : String, onClick : msg }
    , link : Maybe { label : String, url : String }
    }
    -> Html msg
viewControlsRight props =
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
