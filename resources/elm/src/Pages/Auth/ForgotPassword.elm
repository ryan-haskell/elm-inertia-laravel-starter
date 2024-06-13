module Pages.Auth.ForgotPassword exposing
    ( Props, decoder
    , Model, init, onPropsChanged
    , Msg, update, subscriptions
    , view
    )

{-|

@docs Props, decoder
@docs Model, init, onPropsChanged
@docs Msg, update, subscriptions
@docs view

-}

import Browser
import Components.Form
import Components.Icon
import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes as Attr
import Http
import Json.Decode
import Json.Encode
import Shared
import Url exposing (Url)



-- PROPS


type alias Props =
    { errors : Errors
    , status : Maybe String
    }


decoder : Json.Decode.Decoder Props
decoder =
    Json.Decode.map2 Props
        (Json.Decode.field "errors" errorsDecoder)
        (Json.Decode.field "status" (Json.Decode.maybe Json.Decode.string))


type alias Errors =
    { email : Maybe String
    }


errorsDecoder : Json.Decode.Decoder Errors
errorsDecoder =
    Json.Decode.map Errors
        (Json.Decode.maybe (Json.Decode.field "email" Json.Decode.string))



-- MODEL


type alias Model =
    { email : String
    }


init : Shared.Model -> Url -> Props -> ( Model, Effect Msg )
init shared url props =
    ( { email = ""
      }
    , Effect.none
    )


onPropsChanged : Shared.Model -> Url -> Props -> Model -> ( Model, Effect Msg )
onPropsChanged shared url props model =
    ( model, Effect.none )



-- UPDATE


type Msg
    = EmailChanged String
    | FormSubmitted
    | ApiResponded (Result Http.Error Props)


update : Shared.Model -> Url -> Props -> Msg -> Model -> ( Model, Effect Msg )
update shared url props msg model =
    case msg of
        EmailChanged value ->
            ( { model | email = value }, Effect.none )

        FormSubmitted ->
            let
                form : Json.Encode.Value
                form =
                    Json.Encode.object
                        [ ( "email", Json.Encode.string model.email )
                        ]
            in
            ( model
            , Effect.post
                { url = "/forgot-password"
                , body = Http.jsonBody form
                , decoder = decoder
                , onResponse = ApiResponded
                }
            )

        ApiResponded (Ok _) ->
            ( model, Effect.none )

        ApiResponded (Err httpError) ->
            -- TODO: Handle HTTP errors
            ( model, Effect.none )


subscriptions : Shared.Model -> Url -> Props -> Model -> Sub Msg
subscriptions shared url props model =
    Sub.none



-- VIEW


view : Shared.Model -> Url -> Props -> Model -> Browser.Document Msg
view shared url props model =
    { title = "Forgot Password - Laravel"
    , body =
        [ div [ Attr.class "min-h-screen flex flex-col sm:justify-center items-center pt-6 sm:pt-0 bg-gray-100" ]
            [ a [ Attr.href "/" ] [ Components.Icon.laravelGrayscale ]
            , div [ Attr.class "w-full sm:max-w-md mt-6 px-6 py-4 bg-white shadow-md overflow-hidden sm:rounded-lg" ]
                [ div [ Attr.class "mb-4 text-sm text-gray-600" ]
                    [ text "Forgot your password? No problem. Just let us know your email address and we will email you a password reset link that will allow you to choose a new one."
                    ]
                , case props.status of
                    Just status ->
                        div [ Attr.class "mb-4 text-sm text-blue-600" ] [ text status ]

                    Nothing ->
                        text ""
                , Components.Form.view
                    { autofocusFirstField = True
                    , fields =
                        [ Components.Form.EmailInput
                            { id = "email"
                            , label = "Email"
                            , value = model.email
                            , onInput = EmailChanged
                            , required = True
                            , error = props.errors.email
                            }
                        ]
                    , controls =
                        Components.Form.ControlsRight
                            { button =
                                { label = "Email password reset link"
                                , onClick = FormSubmitted
                                }
                            , link = Nothing
                            }
                    }
                ]
            ]
        ]
    }
